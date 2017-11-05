require 'test_helper'

class EntryAddingTest < ActionDispatch::IntegrationTest
  setup do
    @entry = create(:entry)
    @user = create(:user)
  end

  test "should ask the user to login for index" do
    get entries_url
    assert_redirected_to new_user_session_url
  end

  test "should ask the user to login for show" do
    get entry_url(@entry)
    assert_redirected_to new_user_session_url
  end

  test "should create entry" do
    assert_difference('Entry.count') do
      salt = SecureRandom.hex(10)
      hash = Digest::SHA256.hexdigest(Rails.application.secrets[:secret_key_base] + salt)
      post entries_url, as: :json, params: { uid: @user.uid, salt: salt, hash: hash }
      assert_response :created
    end
  end

  test "should get index for a logged in user" do
    sign_in @user
    get entries_url
    assert_response :success
  end

  test "should forbid the access for show if user is not the owner of the entry" do
    sign_in @user
    get entry_url(@entry)
    assert_response :forbidden
  end

  test "should get show for the owner of the entry" do
    sign_in @entry.user
    get entry_url(@entry)
    assert_response :success
  end
end
