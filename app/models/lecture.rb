class Lecture < ApplicationRecord
  scope :in_progress, -> { where("dtstop > ?", Time.zone.now) }
  belongs_to :user
  has_many :entries
  validates :dtstart, presence: true
end
