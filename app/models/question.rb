class Question < ApplicationRecord
  include Rateable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  has_many :subscriptions, dependent: :destroy

  after_create :subscribe_author
  after_save ThinkingSphinx::RealTime.callback_for(:question)

  validates :title, :body, presence: true
  scope :by_last, -> { order(created_at: :desc) }
  scope :by_latest, -> { where(created_at: 1.day.ago..Time.zone.now) }
  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def subscribe_author
    subscriptions.create(user: user)
  end
end
