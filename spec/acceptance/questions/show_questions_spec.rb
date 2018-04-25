require 'rails_helper'

feature 'Index questions', %q{
  User can see questions list
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'User tries to check questions list' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
