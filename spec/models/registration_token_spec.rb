require 'rails_helper'

RSpec.describe RegistrationToken, type: :model do
  it { should validate_presence_of(:token) }
  it { should validate_length_of(:token).is_equal_to(32) }
end
