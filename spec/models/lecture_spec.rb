require 'rails_helper'

RSpec.describe Lecture, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:entries) }
  it { should validate_presence_of(:dtstart) }
end
