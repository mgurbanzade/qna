require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it_behaves_like 'rateable'

  describe 'subscribe author method' do
    let(:question) { create(:question) }

    it 'subscribes author for answer notifications after question created' do
      expect(question.subscriptions.count).to eq 1
    end
  end
end
