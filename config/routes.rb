Rails.application.routes.draw do
  resources :entries, only: [:index, :show, :create]
  resources :lectures, except: :destroy
  devise_for :users, skip: :registrations
  devise_scope :user do
    get 'users/registration_error', to: 'users/registrations#registration_error', as: 'registration_error'
    resource :registration,
      only: [:new, :create, :edit, :update],
      path: 'users',
      path_names: { new: 'sign_up' },
      controller: 'users/registrations',
      as: :user_registration do
        get :cancel
      end
  end
  root 'welcome#index'
end
