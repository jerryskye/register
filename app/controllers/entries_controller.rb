class EntriesController < ApplicationController
  skip_forgery_protection only: [:create]
  before_action :authenticate_user!, only: [:index, :show]
  before_action :validate_jwt, only: [:create]

  # GET /entries
  # GET /entries.json
  def index
    @entries = current_user.entries.left_joins(:lecture).includes(:lecture)
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = current_user.entries.find(params.require(:id))
    @lecture = LectureViewObject.new(@entry.lecture)
  end

  # POST /entries.json
  def create
    uid = params.require(:uid)
    @user = User.find_by(uid: uid)

    result = if @user&.admin?
               AddLecture.call(@user, @device_id)
             else
               AddEntry.call(uid, @device_id)
             end

    if result.success?
      render json: result.success, status: :created
    else
      render json: result.failure, status: :unprocessable_entity
    end
  end

  private

  def validate_jwt
    authenticate_or_request_with_http_token do |token, options|
      begin
        @device_id = JWT.decode(
          token,
          Rails.application.credentials.jwt_secret,
          true,
          { algorithm: 'HS256' }).
        first.fetch('device_id')
      rescue JWT::DecodeError, KeyError
        render(plain: "You didn't say the magic word!", status: :unauthorized)
      end
    end
  end
end
