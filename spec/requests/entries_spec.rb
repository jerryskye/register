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
  end

  describe 'GET /entries' do
    subject { get entries_url }

    include_examples 'require login'
  end

  describe 'POST /entries.json' do
    subject { post entries_url, as: :json, params: { uid: user.uid, salt: salt, hash: hash } }
    let(:salt) { SecureRandom.hex(10) }
    let(:hash) { Digest::SHA256.hexdigest(Rails.application.credentials.secret_key_base + salt) }

    context 'with correct params' do
      let!(:lecture) { create(:lecture) }

      include_examples 'entry adding'

      it 'adds the entry to the lecture' do
        expect { subject }.to change { lecture.entries.count }.by(1)
      end
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

    context 'with incorrect params' do
      context 'with no key' do
        let(:hash) { Digest::SHA256.hexdigest(salt) }

        it 'responds with 403' do
          subject
          expect(response).to have_http_status(403)
        end

        it "explains why it didn't let the user in" do
          subject
          expect(response.body).to eq("You didn't say the magic word!")
        end

        it "doesn't create any entry" do
          expect{ subject }.not_to change { Entry.count }
        end
      end

      context 'with invalid uid' do
        let!(:user) { create(:user) }

        it 'responds with 422' do
          allow(user).to receive(:uid) { Digest::SHA256.hexdigest('foo') }
          subject
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe 'GET /entries/:id' do
    let!(:my_entry) { create(:entry, user: user) }
    let!(:other_entry) { create(:entry) }
    subject { get entry_url(my_entry) }

    include_examples 'require login'

    context 'for a user not owning the entry' do
      subject { get entry_url(other_entry) }

      it 'responds with 403' do
        sign_in user
        subject
        expect(response).to have_http_status(403)
      end
    end
  end
end
