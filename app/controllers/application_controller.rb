# A base class for all controllers in the project
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
