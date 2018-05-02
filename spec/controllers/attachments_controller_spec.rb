require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }
  let!(:attachment) { create(:attachment, attachable: question) }
  let(:random_user) { create(:user) }
  let(:random_question) { create(:question, user: random_user) }
  let!(:random_file) { create(:attachment, attachable: random_question) }

  describe 'DELETE #destroy' do
    context 'User tries to delete his own attachment' do
      it 'deletes the attachment' do
        expect { delete :destroy, params: { id: attachment }, format: :js }.to change(question.attachments, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: attachment }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "User tries to delete not his own attachment" do
      it 'does not delete the attachment' do
        expect { delete :destroy, params: { id: random_file }, format: :js }.to_not change(Attachment, :count)
      end
    end
  end
end
