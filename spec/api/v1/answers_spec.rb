require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it_behaves_like 'API Authenticatable'

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Request Success'
      it_behaves_like 'List of Objects', 'question answers', 3

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it_behaves_like 'API Authenticatable'

    context "authorized" do
      let!(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
      let!(:comment) { comments.first }
      let!(:attachments) { create_list(:attachment, 3, attachable: answer) }
      let!(:attachment) { attachments.first }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Request Success'

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context "comments" do
        it_behaves_like 'List of Objects', 'answer comments', 3, 'comments'

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/2/#{attr}")
          end
        end
      end

      context "attachments" do
        it_behaves_like 'List of Objects', 'answer attachments', 3, 'attachments'

        it "contains a file" do
          expect(response.body).to be_json_eql(attachment.file.to_json).at_path('attachments/2/file')
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it_behaves_like 'API Authenticatable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it_behaves_like 'Valid Attributes', 'answer', Answer
      it_behaves_like 'Invalid Attributes', 'answer', Answer
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json } .merge(options)
    end
  end
end
