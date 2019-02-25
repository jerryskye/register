class AddEntry < ApplicationService
  def call(uid, device_id)
    lecture = Lecture.in_progress.find_by(device_id: device_id)
    entry = Entry.create(uid: uid, lecture: lecture, device_id: device_id)
    if entry.persisted?
      Success(entry)
    else
      Failure(entry.errors)
    end
  end
end
