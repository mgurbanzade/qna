require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe "author_of?(resource) method" do
    let(:users) { create_list(:user, 2) }
    let(:question) { create(:question, user: users.first ) }

    it "should confirm that first user is an author of the passed resource" do
      expect(users.first.author_of?(question)).to eq true
    end

    it "should deny that second user is an author of the passed resource" do
      expect(users.second.author_of?(question)).to eq false
    end
  end
end
