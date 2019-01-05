require 'rails_helper'

RSpec.describe AddLecture do
  include ActiveSupport::Testing::TimeHelpers

  subject { described_class.call(admin, device_id) }
  let!(:admin) { create(:admin) }
  let(:device_id) { 'device-id' }

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

    it 'has correct attributes' do
      freeze_time do
        expect(subject.success).
          to have_attributes(dtstart: Time.current,
                             dtend: 90.minutes.from_now,
                             device_id: device_id)
      end
    end
  end

  context 'for a pre-created lecture' do
    let!(:lecture) { create(:lecture, user: admin, device_id: lecture_device_id) }

    context 'for a different device_id' do
      let(:lecture_device_id) { 'other-id' }

      it 'creates a new lecture' do
        expect { subject }.to change { Lecture.count }.by(1)
      end
    end

    context 'for the same device_id' do
      let(:lecture_device_id) { device_id }

      around do |example|
        freeze_time { example.run }
      end

      it "doesn't create a new lecture" do
        expect { subject }.not_to change { Lecture.count }
      end

      it 'concludes it by updating dtend' do
        expect { subject }.to change { lecture.reload.dtend }.
          from(lecture.dtstart + 90.minutes).to(Time.current)
      end
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
