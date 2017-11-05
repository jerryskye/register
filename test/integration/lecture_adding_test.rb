require 'test_helper'

class LectureAddingTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @admin = create(:admin)
    @second_admin = create(:admin)
    @lecture = create(:lecture, user: @second_admin)
  end

  test "should create a lecture when creating an entry by an admin" do
    assert_difference('Lecture.count') do
      salt = SecureRandom.hex(10)
      hash = Digest::SHA256.hexdigest(Rails.application.secrets[:secret_key_base] + salt)
      post entries_url, as: :json, params: { uid: @admin.uid, salt: salt, hash: hash }
      assert_response :created
    end
  end

  test "should update dtstop for a pre-created lecture" do
    assert_changes('@lecture.reload.dtstop') do
      salt = SecureRandom.hex(10)
      hash = Digest::SHA256.hexdigest(Rails.application.secrets[:secret_key_base] + salt)
      post entries_url, as: :json, params: { uid: @second_admin.uid, salt: salt, hash: hash }
      assert_response :created
    end
  end

  test "should add a user's entry to the lecture" do
    assert_difference('@lecture.reload.entries.count') do
      salt = SecureRandom.hex(10)
      hash = Digest::SHA256.hexdigest(Rails.application.secrets[:secret_key_base] + salt)
      post entries_url, as: :json, params: { uid: @user.uid, salt: salt, hash: hash }
      assert_response :created
    end
  end
end
