FactoryBot.define do
  factory :entry do
    uid { Faker::Crypto.sha256 }
    lecture
  end
end
