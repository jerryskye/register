require 'rails_helper'

RSpec.describe AddEntry do
  subject { described_class.call(uid) }
  let!(:user) { create(:user) }
  let(:uid) { user.uid }

  shared_examples 'entry adding' do
    it 'creates the entry' do
      expect { subject }.to change { Entry.count }.by(1)
    end

    it 'returns a successful result' do
      expect(subject).to be_success
    end

    it 'returns a wrapped entry object' do
      expect(subject.success).to be_instance_of(Entry)
    end
  end

  context 'for no lecture in progress' do
    include_examples 'entry adding'

    it "isn't bound to any lecture" do
      expect(subject.success.lecture).to be_nil
    end
  end

  context 'for a lecture in progress' do
    let!(:lecture) { create(:lecture) }

    include_examples 'entry adding'

    it 'adds an entry to the lecture' do
      expect { subject }.to change { lecture.entries.count }.by(1)
    end
  end

  context 'for a non-registered user' do
    let(:uid) { Faker::Crypto.sha256 }

    include_examples 'entry adding'
  end

  context 'for a failure' do
    context 'for a nil uid' do
      let(:uid) { nil }

      it 'returns a failure result' do
        expect(subject).to be_failure
      end

      it 'returns a wrapped errors object' do
        expect(subject.failure).to be_instance_of(ActiveModel::Errors)
      end
    end
  end
end
