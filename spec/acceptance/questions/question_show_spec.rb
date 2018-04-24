require 'rails_helper'

feature 'Question show', %q{
  User can check the question page and see its answers
} do

  given(:user) { create(:user) }

  scenario 'User tries to check the question page' do
    question = create(:question, user: user)
    visit questions_path
    expect(page).to have_content question.title
    click_on question.title
    expect(page).to have_content question.body
    expect(current_path).to eq question_path(question)
  end
end
