require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:lecture)
end
