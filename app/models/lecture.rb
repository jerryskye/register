class Lecture < ApplicationRecord
  belongs_to :user
  has_many :entries
  validates :dtstart, presence: true
end
