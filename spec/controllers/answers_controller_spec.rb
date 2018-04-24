require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new, related to question answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    context 'delete own answer' do
      it "deletes user's own answer" do
        expect { delete :destroy, params: { id: answer.id, question_id: question.id } }.to change(Answer, :count).by(-1)
      end
    end
  end
end
