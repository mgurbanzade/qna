class Answer < ApplicationRecord
  include Rateable
  include Commentable

  has_many :attachments, as: :attachable
  belongs_to :user
  belongs_to :question, touch: true

  validates :body, presence: true
  after_create :notify_subscribers
  scope :by_best, -> { order(best: :desc, created_at: :asc) }
  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  def toggle_best!
    best_answer = question.answers.find_by(best: true)
    best_answer.update!(best: false) unless best_answer.nil?

    transaction do
      return self.update!(best: false) if self.best
      self.update!(best: true)
    end
  end

  def notify_subscribers
    AnswerNotificationsJob.perform_later(self)
  end
end
