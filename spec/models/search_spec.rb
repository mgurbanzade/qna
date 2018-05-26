require 'rails_helper'

RSpec.describe Search do
  describe '.search' do
    %w(Questions Answers Comments).each do |resource|
      it "returns array of #{resource}" do
        expect(ThinkingSphinx).to receive(:search).with('test search', classes: [resource.singularize.classify.constantize])
        Search.query('test search', "#{resource}")
      end
    end

    it "returns All types of resources" do
      expect(ThinkingSphinx).to receive(:search).with('test search')
      Search.query('test search', 'All')
    end

    it "Invalid condition" do
      result = Search.query('test search', 'blah blah blah')
      expect(result).to eql []
    end
  end
end
