class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  scope :by_last, -> { order(created_at: :desc) }
end
