# A service that handles a submission by an admin
class AddLecture < ApplicationService
  # Creates a new lecture for a specific admin user
  # @param [User] admin the admin record
  # @param [String] device_id submitter device ID
  # @return [Dry::Monads::Result] monad with encapsulated data
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
