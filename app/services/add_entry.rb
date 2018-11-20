class AddEntry < ApplicationService
  def call(user)
    lecture_id = Lecture.in_progress.take&.id
    entry = Entry.create(user: user, lecture_id: lecture_id)
    if entry.persisted?
      Success(entry)
    else
      Failure(entry.errors)
    end
  end
end
