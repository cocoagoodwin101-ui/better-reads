class Book < ApplicationRecord
  validates :title, presence: true
  belongs_to :author
  has_many :reviews, dependent: :destroy
  has_many :upvotes, dependent: :destroy
end
