class AddLecture < ApplicationService
  def call(admin)
    lecture = admin.lectures.in_progress.take
    if lecture.nil?
      lecture = admin.lectures.create(dtstart: Time.current, dtend: 90.minutes.from_now)
      lecture.persisted? ? Success(lecture) : Failure(lecture.errors)
    else
      lecture.update(dtend: Time.current) ? Success(lecture) : Failure(lecture.errors)
    end
  end
end
