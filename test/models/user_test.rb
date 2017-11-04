require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:entries)
  should have_many(:lectures)
  should validate_presence_of(:name)
  should validate_presence_of(:uid)
end
