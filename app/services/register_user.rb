class RegisterUser < ApplicationService
  include Dry::Monads::Do.for(:call)

  def call(registration_token, uid, user_params)
  end
end
