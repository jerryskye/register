module LecturesHelper
  def user_string(user)
    user.nil? ? "Unregistered user" : "#{user.name} (#{user.album_no})"
  end
end
