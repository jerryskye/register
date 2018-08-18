FactoryBot.define do
  factory :registration_token do
    token { SecureRandom.hex(16) }

    factory :admin_registration_token do
      admin { true }
    end
  end
end
