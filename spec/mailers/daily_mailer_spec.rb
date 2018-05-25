require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyMailer.digest(user) }
    let(:questions) { create_list(:question, 2, user: user) }
    let(:questions2) { create_list(:question, 2, user: user, created_at: 2.days.ago) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq(["user1@mail.com"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it 'renders questions created for last 24 hours' do
      questions.each do |question|
        expect(mail.body.encoded).to match(question.title)
      end
    end

    it 'does not render questions created earlier' do
      questions2.each do |question|
        expect(mail.body.encoded).to_not match(question.title)
      end
    end
  end
end
