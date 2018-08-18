class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :lecture, optional: true

  before_create do |entry|
    if entry.user.admin?
      entry.lecture = entry.user.lectures.in_progress.take
      if entry.lecture.nil?
        entry.lecture = Lecture.create(dtstart: Time.current, dtstop: 90.minutes.from_now, user: entry.user)
      else
        entry.lecture.update(dtstop: Time.current)
      end
    else
      entry.lecture = Lecture.in_progress.take
    end
  end
end
