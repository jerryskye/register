FactoryBot.define do
  factory :registration_token do
    token { SecureRandom.hex(16) }
  end
end
