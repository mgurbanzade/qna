require_relative '../acceptance_helper'

feature 'Index questions', %q{
  User can see questions list
} do

  given!(:questions) { create_list(:question, 3) }

  scenario 'User tries to check questions list' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
