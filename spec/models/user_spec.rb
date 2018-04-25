require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe "author_of?(resource) method" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user1 ) }

    it "should confirm that user1 is an author of the passed resource" do
      expect(user1).to be_author_of(question)
    end

    it "should deny that user2 is an author of the passed resource" do
      expect(user2).to_not be_author_of(question)
    end
  end
end
