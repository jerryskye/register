Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    get 'users/registration_error', to: 'users/registrations#registration_error', as: 'registration_error'
  end
end
