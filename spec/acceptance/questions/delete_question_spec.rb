require 'rails_helper'

feature 'Delete question', %q{
  As an authenticated user
  I want to be able to delete my questions
} do

  given!(:question) { create(:question) }
  given(:user2) { create(:user) }

  scenario 'Authenticated user deletes his question' do
    sign_in(question.user)
    click_on 'Delete'
    expect(page).to have_content 'The question is successfully deleted.'
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'Authenticated user tries to delete not his own question' do
    sign_in(user2)
    visit questions_path
    expect(page).to_not have_content 'Delete'
  end

  scenario 'Non-authenticated user tries to delete a question' do
    visit questions_path
    expect(page).to_not have_content 'Delete'
  end
end
