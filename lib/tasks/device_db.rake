namespace :device do
  desc "Create an SQLite db with the secret data for a device"
  task get_db: :environment do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/tokens.sqlite3')
    ActiveRecord::Schema.define do
      create_table(:secret, id: false) do |t|
        t.string :secret
        t.string :device_id
      end
    end
    ActiveRecord::Base.connection.execute("insert into secret values ('#{Rails.application.credentials.jwt_secret}', '#{Faker::Crypto.sha256}');")
  end
end
