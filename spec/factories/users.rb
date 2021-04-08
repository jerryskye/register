FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    name { Faker::Name.name }
    album_no { Faker::Number.number(digits: 6) }
    uid { Faker::Crypto.sha256 }

    factory :admin do
      admin { true }
    end
  end
end
