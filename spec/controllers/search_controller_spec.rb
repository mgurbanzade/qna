require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    %w(All Questions Answers Comments).each do |resource|
      it "searches for resource: #{resource}" do
        expect(Search).to receive(:query).with('test query', resource)
        get :index, params: { query: 'test query', resource: resource }
      end
    end


    it 'renders index template' do
      get :index, params: { query: 'test query', resource: 'All' }
      expect(response).to render_template :index
    end
  end
end
