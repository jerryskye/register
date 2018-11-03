class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to current_user.admin? ? lectures_path : entries_path
    else
      redirect_to new_user_session_path
    end
  end
end
