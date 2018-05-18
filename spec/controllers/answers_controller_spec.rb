require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }
  let!(:answer) { create(:answer, question: question, user: @user) }
  let(:random_user) { create(:user) }
  let!(:random_answer) { create(:answer, question: question, user: random_user) }

  it_behaves_like 'rated' do
    let(:resource) { create(:answer, user: random_user) }
    let(:author_resource) { create(:answer, user: @user) }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new, related to question answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'is linked to user' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(@user.answers, :count).by(1)
      end

      it 'renders answers/create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question answer' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders answers/create template' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'attempt to update user\'s own answer' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'updates user\'s own answer' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'attempt to update other user\'s answer' do
      it 'does not update other user\'s answer' do
        init_body = random_answer.body
        patch :update, params: { id: random_answer, question_id: question, answer: { body: 'attempt to edit answer'} }, format: :js
        random_answer.reload
        expect(random_answer.body).to eq init_body
      end
    end
  end

  describe 'PATCH #best_answer' do
    let!(:random_question) { create(:question, user: random_user) }
    let(:random_answer) { create(:answer, question: random_question, user: random_user) }
    let(:random_answer2) { create(:answer, question: question, user: random_user) }

    it 'assigns answer to @answer' do
      patch :best_answer, params: { id: answer }, format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'chooses the best answer for the question' do
      patch :best_answer, params: { id: random_answer2 }, format: :js
      random_answer2.reload
      expect(random_answer2).to be_best
    end

    it "doesn't choose best answer for other user's question" do
      patch :best_answer, params: { id: random_answer }, format: :js
    end
  end

  describe 'DELETE #destroy' do
    context 'attempt to delete own answer' do
      it 'deletes user\'s own answer' do
        expect { delete :destroy, params: { id: answer.id, question_id: question.id }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer, question_id: question.id  }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context ' attempt to delete not own answer' do
      it 'does not delete other user\'s answer' do
        expect { delete :destroy, params: { id: random_answer, question_id: question.id }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer,  question_id: question.id }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
