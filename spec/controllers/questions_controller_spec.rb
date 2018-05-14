require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let(:random_user) { create(:user) }
  let(:random_question) { create(:question, user: random_user) }

  it_behaves_like 'rated' do
    let(:resource) { create(:question, user: random_user) }
    let(:author_resource) { create(:question, user: @user) }
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) }, format: :js }.to change(@user.questions, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question: attributes_for(:question) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) }, format: :js }.to_not change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'attempt to update user\'s own question' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'updates user own question\'s title' do
        patch :update, params: { id: question, question: { title: 'new title' } }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
      end

      it 'updates user own question\'s body' do
        patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
        question.reload
        expect(question.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { question }

    context 'delete own question' do
      it "deletes user's own question" do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
