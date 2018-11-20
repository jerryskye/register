require 'rails_helper'

RSpec.describe AddLecture do
  include ActiveSupport::Testing::TimeHelpers

  subject { described_class.call(admin) }
  let!(:admin) { create(:admin) }

  context 'for a new lecture' do
    it 'creates the lecture' do
      expect { subject }.to change { Lecture.count }.by(1)
    end

    it 'returns a successful result' do
      expect(subject).to be_success
    end

    it 'returns a wrapped lecture object' do
      expect(subject.success).to be_instance_of(Lecture)
    end

    context 'has correct attributes' do
      around do |example|
        freeze_time { example.run }
      end

      it 'defaults to a lecture lasting 90 minutes' do
        expect(subject.success).to have_attributes(dtstart: Time.current, dtend: 90.minutes.from_now)
      end
    end
  end

  context 'for a pre-created lecture' do
    let!(:lecture) { create(:lecture, user: admin) }

    around do |example|
      freeze_time { example.run }
    end

    it 'concludes it by updating dtend' do
      expect { subject }.to change { lecture.reload.dtend }.from(lecture.dtstart + 90.minutes).to(Time.current)
    end
  end

  context 'for a failure' do
    let(:errors) { { dtend: ["can't be blank"] } }
    before { allow(admin.lectures).to receive(:create).and_return(double(persisted?: false, errors: errors)) }

    it 'returns a failure result' do
      expect(subject).to be_failure
    end

    it 'returns a wrapped errors object' do
      expect(subject.failure).to eq(errors)
    end
  end
end
