class EntriesController < ApplicationController
  skip_forgery_protection only: [:create]
  before_action :authenticate_user!, only: [:index, :show]
  before_action :validate_jwt, only: [:create]

  # GET /entries
  # GET /entries.json
  def index
    @entries = current_user.entries.includes(:lecture)
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = current_user.entries.find(params.require(:id))
  end

  # POST /entries.json
  def create
    @user = User.find_by(uid: params.require(:uid))

    result = if @user.admin?
               AddLecture.call(@user)
             else
               AddEntry.call(@user)
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
        JWT.decode(token, Rails.application.credentials.hmac_secret, true, { algorithm: 'HS256' })
      rescue JWT::DecodeError
        render(plain: "You didn't say the magic word!", status: :unauthorized)
      end
    end
  end
end
