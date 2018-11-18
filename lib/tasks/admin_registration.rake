namespace :admin_registration do
  desc "Generate a registration url for an admin card"
  task :get_url, [:uid, :base_url] => :environment do |task, args|
    raise 'You need to provide uid and base_url as arguments' if args.count != 2
    uid = args[:uid]
    base_url = args[:base_url]
    rt = FactoryBot.create(:registration_token, admin: true).token
    hmac = OpenSSL::HMAC.hexdigest("SHA256", Rails.application.credentials.hmac_secret, rt)
    include Rails.application.routes.url_helpers
    puts base_url + new_user_registration_path(uid: uid, hmac: hmac, token: rt)
  end
end
