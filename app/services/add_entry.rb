class AddEntry < ApplicationService
  def call(uid)
    lecture_id = Lecture.in_progress.take&.id
    entry = Entry.create(uid: uid, lecture_id: lecture_id)
    if entry.persisted?
      Success(entry)
    else
      Failure(entry.errors)
    end
  end
end
