require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'authenticated user' do
    let(:user) { create :user }
    let(:user2) { create :user }
    let(:question) { create :question, user: user }
    let(:question2) { create :question, user: user2 }
    let(:answer) { create :answer, user: user, question: question }
    let(:answer2) { create :answer, user: user2, question: question2 }
    let(:answer3) { create :answer, user: user2, question: question }
    let(:question_attachment) { create :attachment, attachable: question }
    let(:question_attachment2) { create :attachment, attachable: question2 }
    let(:answer_attachment) { create :attachment, attachable: answer }
    let(:answer_attachment2) { create :attachment, attachable: answer2 }

    it { should_not be_able_to :manage, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :update, question }
      it { should be_able_to :destroy, question }
      it { should be_able_to :destroy, question_attachment }
      it { should be_able_to [:like, :dislike], question2 }
      it { should_not be_able_to :update, question2 }
      it { should_not be_able_to :destroy, question2 }
      it { should_not be_able_to [:like, :dislike], question }
      it { should_not be_able_to :destroy, question_attachment2 }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :update, answer }
      it { should be_able_to :destroy, answer }
      it { should be_able_to :destroy, answer_attachment }
      it { should be_able_to [:like, :dislike], answer2 }
      it { should be_able_to :best_answer, answer3 }
      it { should_not be_able_to :update, answer2 }
      it { should_not be_able_to :destroy, answer2 }
      it { should_not be_able_to :destroy, answer_attachment2 }
      it { should_not be_able_to [:like, :dislike], answer }
      it { should_not be_able_to :best_answer, answer }
      it { should_not be_able_to :best_answer, answer2 }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end

    context "Subscription" do
      let(:subscription) { question.subscriptions.first }
      let(:subscription2) { create :subscription }

      it { should be_able_to :create, Subscription }
      it { should be_able_to :destroy, subscription, user: user }
      it { should_not be_able_to :destroy, subscription2, user: user }
    end
  end

  describe 'non authenticated user' do
    let(:user) { nil }
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
  end
end
