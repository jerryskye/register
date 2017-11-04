require 'test_helper'

class LectureTest < ActiveSupport::TestCase
  should belong_to(:user)
  should have_many(:entries)
  should validate_presence_of(:dtstart)
end
