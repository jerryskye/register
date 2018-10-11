require 'rails_helper'

RSpec.describe 'Entries', type: :request do
  let!(:user) { create(:user) }

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

  shared_examples 'entry adding' do
    it 'responds with 201' do
      subject
      expect(response).to have_http_status(201)
    end

    it 'creates an entry' do
      expect{ subject }.to change { Entry.count }.by(1)
    end

    it 'responds with created entry data' do
      fields = [:id, :user_id, :lecture_id]
      subject
      expect(JSON.parse(response.body)).to include(Entry.select(fields).last.attributes)
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
    subject { post entries_url, as: :json, headers: headers, params: { uid: user.uid } }
    let(:headers) { { 'Authorization' => "Bearer #{jwt_token}" } }
    let(:jwt_token) { JWT.encode(jwt_payload, jwt_secret, 'HS256') }
    let(:jwt_payload) { { exp: 5.seconds.from_now.to_i } }
    let(:jwt_secret) { Rails.application.credentials.hmac_secret }
    let(:error_response_body) { "You didn't say the magic word!" }

    context 'with correct token' do
      let!(:lecture) { create(:lecture) }

      include_examples 'entry adding'

      it 'adds the entry to the lecture' do
        expect { subject }.to change { lecture.entries.count }.by(1)
      end

      context 'for an admin user' do
        let!(:user) { create(:admin) }

        include_examples 'entry adding'

        it 'creates a lecture' do
          expect { subject }.to change { Lecture.count }.by(1)
        end

        context 'for a pre-created lecture' do
          let!(:lecture) { create(:lecture, user: user) }

          around do |example|
            Timecop.freeze(Time.current.round)
            example.run
            Timecop.return
          end

          it 'concludes it by updating dtstop' do
            expect { subject }.to change { lecture.reload.dtstop }.from(lecture.dtstart + 90.minutes).to(Time.current)
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
      let(:jwt_payload) { { exp: 5.seconds.ago.to_i } }

      include_examples 'invalid credentials'
    end
  end

  describe 'GET /entries/:id' do
    let!(:my_entry) { create(:entry, user: user) }
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
