class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :entries
  has_many :lectures
  validates :name, presence: true
  validates :uid, presence: true, uniqueness: { message: 'is taken - this card has already been registered!' }, length: { is: 64 }

  def self.new_with_session(params, session)
    new(params.merge(session.to_hash.slice('uid', 'admin')))
  end
end
