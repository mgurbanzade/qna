require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to :question }

  describe "toggle_best! method" do
    let(:answer) { create(:answer) }
    let(:best_answer) { create(:answer, best: true) }

    it "should mark answer as the best" do
      answer.toggle_best!
      answer.reload
      expect(answer).to be_best
    end

    it "should remove best flag" do
      best_answer.toggle_best!
      best_answer.reload
      expect(best_answer).to_not be_best
    end
  end
end
