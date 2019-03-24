# A service that adds a new entry to the database
class AddEntry < ApplicationService
  # Creates and associates a new entry with a lecture in progress
  # @param [String] uid NFC card identifier
  # @param [String] device_id submitter device ID
  # @return [Dry::Monads::Result] monad with encapsulated data
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
