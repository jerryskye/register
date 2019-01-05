require 'rails_helper'

RSpec.describe 'Entries', type: :request do
  let!(:user) { create(:user) }
  let(:uid) { user.uid }

  shared_examples 'require login' do
    it 'redirects a non-logged in user to login page' do
      expect(subject).to redirect_to(new_user_session_url)
    end

    it 'responds with 200 to a logged in user' do
      sign_in user
      subject
      expect(response).to have_http_status(200)
    end
  end

  shared_examples 'invalid credentials' do
    it 'responds with 401' do
      subject
      expect(response).to have_http_status(401)
    end

    it "explains why it didn't let the user in" do
      subject
      expect(response.body).to eq(error_response_body)
    end

    it "doesn't create any entry" do
      expect{ subject }.not_to change { Entry.count }
    end
  end

  describe 'GET /entries' do
    subject { get entries_url }

    include_examples 'require login'
  end

  describe 'POST /entries.json' do
    subject { post entries_url, as: :json, headers: headers, params: { uid: uid } }
    let(:headers) { { 'Authorization' => "Bearer #{jwt_token}" } }
    let(:jwt_token) { JWT.encode(jwt_payload, jwt_secret, 'HS256') }
    let(:jwt_payload) { { exp: exp, device_id: device_id } }
    let(:jwt_secret) { Rails.application.credentials.hmac_secret }
    let(:exp) { 5.seconds.from_now.to_i }
    let(:device_id) { 'device-id' }
    let(:error_response_body) { "You didn't say the magic word!" }

    context 'with correct token' do
      let(:some_successful_result) { double(success?: true, success: 'hello') }
      context 'for student card' do
        it 'runs the AddEntry service' do
          expect(AddEntry).to receive(:call).with(uid, device_id).and_return(some_successful_result)
          subject
        end

        context 'for successful result' do
          let!(:entry) { create(:entry, uid: uid) }
          let(:successful_result) { double(success?: true, success: entry) }
          before do
            allow(AddEntry).to receive(:call).with(uid, device_id).and_return(successful_result)
          end

          it 'responds with 201' do
            subject
            expect(response).to have_http_status(201)
          end

          it 'responds with created entry data' do
            subject
            expect(response.body).to eq(entry.to_json)
          end
        end

        context 'for failure result' do
          let(:errors) { { errors: { some_field: ['some error'] } } }
          let(:failure_result) { double(success?: false, failure: errors) }
          before do
            allow(AddEntry).to receive(:call).with(uid, device_id).and_return(failure_result)
          end

          it 'responds with 422' do
            subject
            expect(response).to have_http_status(422)
          end

          it 'responds with error data' do
            subject
            expect(response.body).to eq('{"errors":{"some_field":["some error"]}}')
          end
        end
      end

      context 'for an admin user' do
        let!(:lecture) { create(:lecture, user: user) }
        let!(:user) { create(:admin) }

        it 'runs the AddLecture service' do
          expect(AddLecture).to receive(:call).with(user, device_id).and_return(some_successful_result)
          subject
        end

        context 'for successful result' do
          let(:lecture) { create(:lecture, user: user) }
          let(:successful_result) { double(success?: true, success: lecture) }
          before do
            allow(AddLecture).to receive(:call).with(user, device_id).and_return(successful_result)
          end

          it 'responds with 201' do
            subject
            expect(response).to have_http_status(201)
          end

          it 'responds with created lecture data' do
            subject
            expect(response.body).to eq(lecture.to_json)
          end
        end

        context 'for failure result' do
          let(:errors) { { errors: { some_field: ['some error'] } } }
          let(:failure_result) { double(success?: false, failure: errors) }
          before do
            allow(AddLecture).to receive(:call).with(user, device_id).and_return(failure_result)
          end

          it 'responds with 422' do
            subject
            expect(response).to have_http_status(422)
          end

          it 'responds with error data' do
            subject
            expect(response.body).to eq('{"errors":{"some_field":["some error"]}}')
          end
        end
      end
    end

    context 'with no headers whatsoever' do
      let(:headers) { { } }
      let(:error_response_body) { "HTTP Token: Access denied.\n" }

      include_examples 'invalid credentials'
    end

    context 'with invalid JWT secret ' do
      let(:jwt_secret) { 's3cr3t' }

      include_examples 'invalid credentials'
    end

    context 'with expired token ' do
      let(:exp) { 5.seconds.ago.to_i }

      include_examples 'invalid credentials'
    end

    context 'with no device_id' do
      let(:jwt_payload) { { exp: exp } }

      include_examples 'invalid credentials'
    end
  end

  describe 'GET /entries/:id' do
    let!(:my_entry) { create(:entry, uid: uid) }
    let!(:other_entry) { create(:entry) }
    subject { get entry_url(my_entry) }

    include_examples 'require login'

    context 'for a user not owning the entry' do
      subject { get entry_url(other_entry) }

      it 'raises ActiveRecord::RecordNotFound' do
        sign_in user
        expect{ subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
