class EntriesController < ApplicationController
  protect_from_forgery with: :null_session, only: [:create]
  before_action :authenticate_user!, only: [:index, :show]
  before_action :validate_jwt, only: [:create]

  # GET /entries
  # GET /entries.json
  def index
    @entries = current_user.entries
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = Entry.find(params.require(:id))
    render(status: :forbidden) unless @entry.user == current_user
  end

  # POST /entries.json
  def create
    @user = User.find_by(uid: params.require(:uid))
    @entry = Entry.new(user: @user)

    respond_to do |format|
      if @entry.save
        format.json { render :show, status: :created, location: @entry }
      else
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
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
