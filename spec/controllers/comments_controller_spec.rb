require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user
  let!(:resource) { create(:question, user: @user) }

  describe 'POST #create' do
    context 'Comments with valid params' do
      it 'creates new comment in database' do
        expect { post :create, params: { question_id: resource, comment: attributes_for(:comment) }, format: :js }.to change(resource.comments, :count).by(1)
      end

      it 'renders create teamplate' do
        post :create, params: { question_id: resource, comment: attributes_for(:comment) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'Comments with invalid params' do
      it 'does not create a new comment in database' do
        expect { post :create, params: { question_id: resource, comment: attributes_for(:invalid_comment) }, format: :js }.to_not change(Comment, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: resource, comment: attributes_for(:invalid_comment) }, format: :js
        expect(response).to render_template :create
      end
    end
  end
end
