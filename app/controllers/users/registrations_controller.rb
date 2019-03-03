class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :check_registration_token, only: [:new]

  # GET /resource/sign_up
  def new
    session[:token_id] = @rt.id
    session[:uid] = params.require(:uid)
    session[:admin] = @rt.admin?
    if User.exists?(uid: session[:uid])
      flash[:alert] = 'This card has already been registered!'
      redirect_to registration_error_path
    else
      super
    end
  end

  # POST /resource
  def create
    super do |user|
      if user.persisted?
        RegistrationToken.delete(session.delete(:token_id))
        session.delete(:uid)
        session.delete(:admin)
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def registration_error
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :album_no])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :album_no])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def check_registration_token
    token = params.require(:token)
    @rt = RegistrationToken.find_by(token: token)
    hmac = OpenSSL::HMAC.hexdigest("SHA256", Rails.application.credentials.jwt_secret, token)
    return if @rt and hmac == params.require(:hmac)
    flash[:alert] = "You need a valid registration token and UID."
    redirect_to registration_error_path
  end
end
