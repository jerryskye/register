FactoryBot.define do
  factory :lecture do
    subject { Faker::ProgrammingLanguage.name }
    dtstart { DateTime.now }
    dtstop { 90.minutes.from_now }
    association :user, factory: :admin
  end
end
