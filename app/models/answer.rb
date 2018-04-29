class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, presence: true
  scope :by_best, -> { order(best: :desc, created_at: :asc) }

  def toggle_best!
    best_answer = question.answers.find_by(best: true)
    best_answer.update!(best: false) unless best_answer.nil?

    if self.best
      self.update!(best: false)
    else
      self.update!(best: true)
    end
  end
end
