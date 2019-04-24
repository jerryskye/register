namespace :registration do
  desc "Generate a registration url for a card"
  task :get_url, [:admin, :uid, :host, :exp] => :environment do |task, args|
    raise 'You need to provide admin, uid, host and exp as arguments' if args.count != 4
    admin = args[:admin] == 'true'
    uid = args[:uid]
    host = args[:host]
    exp = args[:exp]
    p admin
    include Rails.application.routes.url_helpers
    jwt_secret = Rails.application.credentials.jwt_secret
    jwt_payload = { exp: exp, sub: uid, admin: admin }
    token = JWT.encode(jwt_payload, jwt_secret, 'HS256')
    puts new_user_registration_url(host: host, token: token)
  end
end
