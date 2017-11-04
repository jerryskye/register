class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :entries
  has_many :lectures
  validates :name, presence: true
  validates :uid, presence: true, uniqueness: true, length: { is: 64 }
end
