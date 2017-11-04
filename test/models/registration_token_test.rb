require 'test_helper'

class RegistrationTokenTest < ActiveSupport::TestCase
  should validate_presence_of(:token)
  should validate_length_of(:token).is_equal_to(32)
end
