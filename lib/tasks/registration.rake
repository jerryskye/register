namespace :registration do
  desc "Generate a registration url for a card"
  task :get_url, [:admin, :uid, :base_url] => :environment do |task, args|
    raise 'You need to provide admin, uid and base_url as arguments' if args.count != 3
    admin = args[:admin]
    uid = args[:uid]
    base_url = args[:base_url]
    rt = FactoryBot.create(:registration_token, admin: admin).token
    hmac = OpenSSL::HMAC.hexdigest("SHA256", Rails.application.credentials.hmac_secret, rt)
    include Rails.application.routes.url_helpers
    puts base_url + new_user_registration_path(uid: uid, hmac: hmac, token: rt)
  end
end
