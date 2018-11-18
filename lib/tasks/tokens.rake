namespace :tokens do
  desc "Generate a 100 tokens"
  task generate: :environment do
    FactoryBot.create_list(:registration_token, 100)
  end

  desc "Create an SQLite db with the token data"
  task get_db: :environment do
    tables = ActiveRecord::Base.connection.tables
    tokens = RegistrationToken.where(admin: false).map {|rt| RegistrationToken.new(token: rt.token) }
    ActiveRecord::SchemaDumper.ignore_tables = tables - [RegistrationToken.table_name]
    strio = StringIO.new
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, strio)
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/tokens.sqlite3')
    eval(strio.string)
    strio.close
    tokens.each(&:save)
    ActiveRecord::Schema.define do
      create_table(:secret, id: false) do |t|
        t.string :secret
      end
    end
    ActiveRecord::Base.connection.execute("insert into secret values ('#{Rails.application.credentials.hmac_secret}');")
  end
end
