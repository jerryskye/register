FactoryBot.define do
  factory :entry do
    device_id { Faker::Crypto.sha256 }
    uid { Faker::Crypto.sha256 }
    lecture { create(:lecture, device_id: device_id) }
  end
end
