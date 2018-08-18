class Lecture < ApplicationRecord
  scope :in_progress, -> { where("dtstop > ?", Time.current) }
  belongs_to :user
  has_many :entries
  validates :dtstart, presence: true
end
