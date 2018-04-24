require 'rails_helper'

feature 'Question show', %q{
  User can see question and its answers
} do

  given(:user) { create(:user) }

  scenario 'User tries to check question page' do
    question = create(:question, user: user)
    visit questions_path
    expect(page).to have_content question.title
    click_on question.title
    expect(page).to have_content question.body
  end
end
