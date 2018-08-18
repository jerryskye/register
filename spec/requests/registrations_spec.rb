require 'rails_helper'

RSpec.describe "User registrations", type: :request do
  describe 'GET /users/sign_up' do
    let(:token) { create(:registration_token).token }
    let(:uid) { Digest::SHA256.hexdigest(SecureRandom.hex(4)) }
    subject do
      get new_user_registration_url,
        params: { token: token, uid: uid, hmac: hmac }
    end

    context 'with valid params' do
    let(:hmac) { OpenSSL::HMAC.hexdigest('SHA256', Rails.application.credentials.hmac_secret, token) }

      it 'responds with 200' do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
    let(:hmac) { OpenSSL::HMAC.hexdigest('SHA256', 'invalid secret', token) }

      it 'redirects to an error page' do
        expect(subject).to redirect_to(registration_error_url)
      end

      it 'displays the error text' do
        subject
        expect(flash[:alert]).to eq('You need a valid registration token and UID.')
      end
    end
  end
end
