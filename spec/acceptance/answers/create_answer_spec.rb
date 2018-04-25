require 'rails_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to response to questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)
    visit question_path(question)
    create_answer
    expect(page).to have_content 'The answer is successfully created.'
    expect(page).to have_content 'My answer'
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)
    create_answer
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user tries to create answer with incorrect attributes' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Reply'
    expect(page).to have_content "Body can't be blank"
  end
end
