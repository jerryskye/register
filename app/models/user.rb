class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :recoverable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
  has_many :lectures, dependent: :destroy
  validates :name, presence: true
  validates :uid, presence: true, uniqueness: { message: 'is taken - this card has already been registered!' }, length: { is: 64 }
  validates :album_no, numericality: { only_integer: true }

  def self.new_with_session(params, session)
    new(params.merge(session.to_hash.slice('uid', 'admin')))
  end

  def entries
    Entry.where(uid: uid)
  end
end
