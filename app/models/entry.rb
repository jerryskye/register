class Entry < ApplicationRecord
  belongs_to :lecture, optional: true
  validates :uid, presence: true, length: { is: 64 }


  def user
    User.find_by(uid: uid)
  end
end
