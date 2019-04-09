# Model class for the +entries+ table
class Entry < ApplicationRecord
  belongs_to :lecture, optional: true
  validates :uid, presence: true, length: { is: 64 }

  # Returns the user object for this entry's uid
  def user
    User.find_by(uid: uid) || NullUser.new
  end
end
