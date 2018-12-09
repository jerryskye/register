require 'rails_helper'

RSpec.describe Entry, type: :model do
  it { should belong_to(:lecture) }
  it { should validate_presence_of(:uid) }
  it { should validate_length_of(:uid).is_equal_to(64) }
end
