require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let(:random_user) { create(:user) }
  let(:random_question) { create(:question, user: random_user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

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

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @questions' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to index view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to questions_path
      end

      it 'renders a flash message' do
        post :create, params: { question: attributes_for(:question) }
        expect(flash[:notice]).to eq 'Question is successfully created.'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 'redirects to new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
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

    context 'attempt to update other user question\'s title' do
      it 'does not update other user question\'s title' do
        init_title = random_question.title
        patch :update, params: { id: random_question, question: { title: 'attempt to question title'} }, format: :js
        random_question.reload
        expect(random_question.title).to eq init_title
      end
    end

    context 'attempt to update other user question\'s body' do
      it 'does not update other user question\'s body' do
        init_body = random_question.body
        patch :update, params: { id: random_question, question: { body: 'attempt to question body'} }, format: :js
        random_question.reload
        expect(random_question.body).to eq init_body
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

    context 'delete not own question' do
      before do
        @random_user = create(:user)
        @random_question = create(:question, user: @random_user)
      end

      it 'tries to delete not user\'s own questions' do
        expect { delete :destroy, params: { id: @random_question } }.to_not change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: @random_question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
