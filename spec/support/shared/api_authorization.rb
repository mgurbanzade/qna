shared_examples_for 'API Authenticatable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(access_token: '1234')
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Request Success' do
  it 'returns 200 status code' do
    expect(response).to be_success
  end
end

shared_examples_for "List of Objects" do |object, size, path = ''|
  it "returns list of #{object}" do
    expect(response.body).to have_json_size(size).at_path(path)
  end
end


shared_examples_for 'Valid Attributes' do |object, model|
  context 'with valid attributes' do
    if object == 'question'
      let(:post_request) { post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, access_token: access_token.token } }
    elsif object == 'answer'
      let(:post_request) { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token } }
    end

    it "creates a new #{object}" do
      post_request
      expect(response).to be_success
    end

    it "saves the #{object} in database" do
      expect { post_request }.to change(model, :count).by(1)
    end
  end
end

shared_examples_for 'Invalid Attributes' do |object, model|
  context 'with valid attributes' do
    if object == 'question'
      let(:post_request) { post '/api/v1/questions', params: { question: attributes_for(:invalid_question), format: :json, access_token: access_token.token } }
    elsif object == 'answer'
      let(:post_request) { post "/api/v1/questions/#{question.id}/answers", params: { answer: attributes_for(:invalid_answer), format: :json, access_token: access_token.token } }
    end

    it 'does not create a question' do
      post_request
      expect(response.status).to eq 422
    end

    it "does not save the #{object} in database" do
      expect { post_request }.to_not change(model, :count)
    end
  end
end
