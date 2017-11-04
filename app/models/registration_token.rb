class RegistrationToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true, length: { is: 32 }
end
