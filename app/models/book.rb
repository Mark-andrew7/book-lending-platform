class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :available, inclusion: { in: [true, false] }
end

