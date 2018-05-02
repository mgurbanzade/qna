class Answer < ApplicationRecord
  has_many :attachments, as: :attachable
  belongs_to :user
  belongs_to :question

  validates :body, presence: true
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
end
