# The controller that handles all requests related to entries
class EntriesController < ApplicationController
  skip_forgery_protection only: [:create]
  before_action :authenticate_user!, only: [:index, :show]
  before_action :validate_jwt, only: [:create]

  # +GET /entries+
  #
  # Returns all the entries for the current user
  def index
    @entries = current_user.entries.left_joins(:lecture).includes(:lecture)
  end

  # +GET /entries/:id+
  #
  # Returns info about an entry with specific id
  def show
    @entry = current_user.entries.find(params.require(:id))
    @lecture = LectureDecorator.new(@entry.lecture)
  end

  # +POST /entries+
  #
  # Creates an entry (or a lecture if the user is an admin)
  def create
    uid, device_id = entry_params
    @user = User.find_by(uid: uid)

    result = if @user&.admin?
               AddLecture.call(@user, device_id)
             else
               AddEntry.call(uid, device_id)
             end

    if result.success?
      render json: result.success, status: :created
    else
      render json: result.failure, status: :unprocessable_entity
    end
  end

  private

  def entry_params
    params.require([:uid, :device_id])
  end

  def validate_jwt
    authenticate_or_request_with_http_token do |token, options|
      JWT.decode(
        token,
        Rails.application.credentials.jwt_secret,
        true,
        { algorithm: 'HS256' }
      )
    rescue JWT::DecodeError
      render(plain: "You didn't say the magic word!", status: :unauthorized)
    end
  end
end
