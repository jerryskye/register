class AddLecture < ApplicationService
  def call(admin, device_id)
    lecture = admin.lectures.in_progress.find_by(device_id: device_id)
    if lecture.nil?
      lecture = admin.lectures.create(
        dtstart: Time.current,
        dtend: 90.minutes.from_now,
        device_id: device_id
      )
      lecture.persisted? ? Success(lecture) : Failure(lecture.errors)
    else
      lecture.update(dtend: Time.current) ? Success(lecture) : Failure(lecture.errors)
    end
  end
end
