require 'rails_helper'

describe 'Question API' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticatable'

    context 'authorized' do
      let(:access_token) { create (:access_token) }
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it_behaves_like 'Request Success'

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it 'question object contains #{attr}' do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
    let(:comment) { comments.first }
    let(:attachment) { attachments.first }
    let!(:attachments) { create_list(:attachment, 2, attachable: question) }

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
      end

      it_behaves_like 'Request Success'

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context 'comments' do
        it 'returns question comments' do
          expect(response.body).to have_json_size(3).at_path('comments')
        end

        %w(id body user_id created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/2/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'returns question attachments' do
          expect(response.body).to have_json_size(2).at_path('attachments')
        end

        it "contains a file" do
          expect(response.body).to be_json_eql(attachment.file.to_json).at_path('attachments/1/file')
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:post_question) { post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token } }
      let(:post_invalid_question) { post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token } }

      context 'with valid attributes' do
        it 'creates new question' do
          post_question
          expect(response).to be_success
        end

        it 'saves the question in database' do
          expect { post_question }.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not create a question' do
          post_invalid_question
          expect(response.status).to eq 422
        end

        it 'does not save the question in database' do
          expect { post_invalid_question }.to_not change(Question, :count)
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', params: { format: :json } .merge(options)
    end
  end
end
