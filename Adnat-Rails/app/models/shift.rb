class Shift < ApplicationRecord
  validates :user, :start, :finish, presence: true
  validates :break_length, numericality: {in: 0..60}

  belongs_to :user, foreign_key: :user_id
end
