require 'rails_helper'

feature 'Delete question', %q{
  As an authenticated user
  I want to be able to delete my questions
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his question' do
    sign_in(user)
    create_question
    click_on 'Delete'
    expect(page).to have_content 'The question is successfully deleted.'
  end

  scenario 'Authenticated user tries to delete not his own question' do
    sign_in(user)
    create_question
    visit questions_path
    click_on 'Log out'
    click_on 'Ask question'
    sign_up(user)
    visit questions_path
    expect(page).to_not have_content 'Delete'
  end
end
