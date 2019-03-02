require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:lectures) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:uid) }
  it { should validate_length_of(:uid).is_equal_to(64) }
  it { should validate_numericality_of(:album_no).only_integer }
end
