require 'rails_helper'

shared_examples 'redirect to registration error page' do
  it 'redirects to an error page' do
    expect(subject).to redirect_to(registration_error_url)
  end

  it 'displays the error text' do
    subject
    expect(flash[:alert]).to eq(alert)
  end
end

RSpec.describe "User registrations", type: :request do
  describe 'GET /users/sign_up' do
    let(:jwt_token) { JWT.encode(jwt_payload, jwt_secret, 'HS256') }
    let(:jwt_payload) { { exp: exp, sub: uid, admin: false } }
    let(:jwt_secret) { Rails.application.credentials.jwt_secret }
    let(:exp) { 5.seconds.from_now.to_i }
    let(:uid) { Digest::SHA256.hexdigest(SecureRandom.hex(4)) }
    let(:alert) { 'You need a valid registration token.' }
    subject { get new_user_registration_url, params: { token: jwt_token } }

    context 'with valid token' do
      it 'responds with 200' do
        subject
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid token' do
      context 'with invalid secret' do
        let(:jwt_secret) { 'nope' }

        include_examples 'redirect to registration error page'
      end

      context 'with no uid' do
        let(:jwt_payload) { { exp: exp } }

        include_examples 'redirect to registration error page'
      end
    end

    context 'with no token' do
      subject { get new_user_registration_url }

      include_examples 'redirect to registration error page'
    end
  end
end
