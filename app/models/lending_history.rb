class LendingHistory < ApplicationRecord
  belongs_to :book
  validates :borrower_name, presence: true
  validates :borrowed_on, presence: true
end

