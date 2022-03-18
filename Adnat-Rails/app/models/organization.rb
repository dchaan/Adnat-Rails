class Organization < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :hourly_rate, numericality: {greater_than_or_equal_to: 0}

  has_many :users, dependent: :nullify
end
