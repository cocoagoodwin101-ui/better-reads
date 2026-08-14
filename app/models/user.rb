class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 7 }

  has_many :reviews
  has_many :upvotes, dependent: :destroy
end
