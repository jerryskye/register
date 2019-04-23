# Model class for the +users+ table
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
  has_many :lectures, dependent: :destroy
  validates :name, presence: true
  validates :uid, presence: true, uniqueness: { message: 'is taken - this card has already been registered!' }, length: { is: 64 }
  validates :album_no, numericality: { only_integer: true }, unless: :admin?

  # Override of the devise method
  # allows passing attributes via session
  def self.new_with_session(params, session)
    new(params.merge(session.to_hash.slice('uid', 'admin')))
  end

  # Returns all entries associated with user's uid
  def entries
    Entry.where(uid: uid)
  end

  def to_s
    "#{name} (#{album_no})"
  end
end
