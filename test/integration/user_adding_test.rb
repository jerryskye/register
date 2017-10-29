require 'test_helper'

class UserAddingTest < ActionDispatch::IntegrationTest
  setup do
    @user_token = registration_tokens(:one)
  end

  test "should show error for no params" do
    get new_user_registration_url
    assert_redirected_to registration_error_path
    assert_equal("You need a valid registration token and UID.", flash[:alert])
  end

  test "should show error for token only" do
    get new_user_registration_url, params: { token: @user_token.token }
    assert_redirected_to registration_error_path
    assert_equal("You need a valid registration token and UID.", flash[:alert])
  end

  test "should show error for no uid" do
    salt = SecureRandom.hex(10)
    hash = Digest::SHA256.hexdigest(Rails.application.secrets[:secret_key_base] + salt)
    get new_user_registration_url, params: { salt: salt, hash: hash, token: @user_token.token}
    assert_redirected_to registration_error_path
    assert_equal("You need a valid registration token and UID.", flash[:alert])
  end

  test "should show error for bad hash" do
    salt = SecureRandom.hex(16)
    hash = Digest::SHA256.hexdigest(salt)
    get new_user_registration_url, params: { salt: salt, hash: hash, token: @user_token.token}
    assert_redirected_to registration_error_path
    assert_equal("You need a valid registration token and UID.", flash[:alert])
  end

  test "should succeed with valid params" do
    salt = SecureRandom.hex(10)
    hash = Digest::SHA256.hexdigest(Rails.application.secrets[:secret_key_base] + salt)
    get new_user_registration_url, params: { uid: Digest::SHA256.hexdigest(SecureRandom.hex(4)), salt: salt, hash: hash, token: @user_token.token}
    assert_response :success
  end

end
