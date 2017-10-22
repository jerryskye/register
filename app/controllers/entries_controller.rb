class EntriesController < ApplicationController
  protect_from_forgery with: :null_session, only: [:create]
  before_action :authenticate_user!, only: [:index, :show]
  before_action :validate_params, only: [:create]

  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.all
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    @entry = Entry.find(params[:id])
  end

  # POST /entries.json
  def create
    @user = User.find_by(uid: params[:uid])
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
    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:uid)
    end

    def validate_params
      if params.has_key?(:salt) and params.has_key?(:hash) and params.has_key?(:uid)
        return if Digest::SHA256.hexdigest(Rails.application.secrets[:secret_key_base] + params[:salt]) == params[:hash]
      end
      render(json: "You didn't say the magic word!", status: :unauthorized)
    end
end
