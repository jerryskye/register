FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    name { Faker::Name.name }
    album_no { Faker::Number.number(6) }
    uid { Faker::Crypto.sha256 }

    factory :admin do
      admin { true }
    end
  end
end
