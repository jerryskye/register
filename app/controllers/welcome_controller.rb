class WelcomeController < ApplicationController
  # +GET /+
  #
  # Redirects to user dashboard (entries or lectures for admins).
  # If user is not signed in, redirects to login page
  def index
    if user_signed_in?
      redirect_to current_user.admin? ? lectures_path : entries_path
    else
      redirect_to new_user_session_path
    end
  end
end
