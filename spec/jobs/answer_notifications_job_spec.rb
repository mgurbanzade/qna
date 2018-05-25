require 'rails_helper'

RSpec.describe AnswerNotificationsJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:users) { create_list(:user, 3) }

  it 'sends a notification email with answer to subscribers' do
    users.each { |user| user.subscriptions.create(question: question) }

    question.subscriptions.each do |subscription|
      expect(AnswerNotificationsMailer).to receive(:notify).with(subscription.user, answer).and_call_original
    end

    AnswerNotificationsJob.perform_now(answer)
  end
end
