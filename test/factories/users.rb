FactoryBot.define do
  factory :user do
    transient do
      random_uid  { SecureRandom.hex(4) }
    end
    email { Faker::Internet.email(random_uid) }
    password "password"
    name { Faker::Name.name }
    album_no { Faker::Number.number(6) }
    uid { Digest::SHA256.hexdigest(random_uid) }

    factory :admin do
      admin true
    end
  end
end
