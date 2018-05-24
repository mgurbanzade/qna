class Question < ApplicationRecord
  include Rateable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :subscriptions, dependent: :destroy

  validates :title, :body, presence: true
  scope :by_last, -> { order(created_at: :desc) }
  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
