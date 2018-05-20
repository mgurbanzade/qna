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

      it 'returns list of question answers' do
        expect(response.body).to have_json_size(3)
      end

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

    context "authorized" do
      let!(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
      let!(:comment) { comments.first }
      let!(:attachments) { create_list(:attachment, 3, attachable: answer) }
      let!(:attachment) { attachments.first }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it "returns 200 status code" do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context "comments" do
        it "returns answer comments" do
          expect(response.body).to have_json_size(3).at_path('comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/2/#{attr}")
          end
        end
      end

      context "attachments" do
        it "returns answer attachments" do
          expect(response.body).to have_json_size(3).at_path('attachments')
        end

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

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:post_answer) { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), question_id: question, format: :json, access_token: access_token.token } }
      let!(:post_invalid_answer) { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), question_id: question, format: :json, access_token: access_token.token } }

      context 'with valid attributes' do
        it 'creates a new question answer' do
          post_answer
          expect(response).to be_success
        end

        it 'saves the question answer in database' do
          expect { post_answer }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not create an answer' do
          post_invalid_answer
          expect(response.status).to eq 422
        end

        it 'does not save the answer in database' do
          expect { post_invalid_answer }.to_not change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
