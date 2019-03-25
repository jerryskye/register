# Model class for the +lectures+ table
class Lecture < ApplicationRecord
  scope :in_progress, -> { where("dtend > ?", Time.current) }
  belongs_to :user
  has_many :entries, dependent: :nullify
  validates :dtstart, presence: true
  validates :device_id, presence: true
end
