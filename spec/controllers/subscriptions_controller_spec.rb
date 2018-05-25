require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:subscription)  { create(:subscription, user: user, question: question) }

  describe 'POST#create' do
    sign_in_user

    it 'assigns subscription to user' do
      expect { post :create, params: { question_id: question, user: @user }, format: :js }.to change(@user.subscriptions, :count).by(1)
    end

    it 'assigns subscription to question' do
      expect { post :create, params: { question_id: question, user: @user }, format: :js }.to change(question.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let!(:subscription2)  { create(:subscription, user: @user, question: question) }

    it 'destroys subscription' do
      expect { delete :destroy, params: { question_id: question, id: subscription2.id }, format: :js }.to change(Subscription, :count).by(-1)
    end
  end
end
