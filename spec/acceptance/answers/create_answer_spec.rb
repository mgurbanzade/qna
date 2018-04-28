require_relative '../acceptance_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to response to questions
} do

  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(question.user)
    visit question_path(question)
    create_answer

    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)
    create_answer
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user tries to create answer with incorrect attributes', js: true do
    sign_in(question.user)
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Reply'
    expect(page).to have_content "Body can't be blank"
  end
end
