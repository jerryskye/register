FactoryBot.define do
  factory :lecture do
    device_id { Faker::Crypto.sha256 }
    subject { Faker::ProgrammingLanguage.name }
    dtstart { DateTime.now }
    dtend { 90.minutes.from_now }
    association :user, factory: :admin
  end
end
