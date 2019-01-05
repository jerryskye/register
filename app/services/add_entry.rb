class AddEntry < ApplicationService
  def call(uid, device_id)
    lecture_id = Lecture.in_progress.find_by(device_id: device_id)&.id
    entry = Entry.create(uid: uid, lecture_id: lecture_id, device_id: device_id)
    if entry.persisted?
      Success(entry)
    else
      Failure(entry.errors)
    end
  end
end
