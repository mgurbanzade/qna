class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable

  validates :title, :body, presence: true
  scope :by_last, -> { order(created_at: :desc) }
  accepts_nested_attributes_for :attachments
end
