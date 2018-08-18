require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:entries) }
  it { should have_many(:lectures) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:uid) }
end
