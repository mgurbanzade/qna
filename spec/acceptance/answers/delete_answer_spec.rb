require 'rails_helper'

feature 'Delete answer', %q{
  As an authenticated user
  I want to be able to delete my answers
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his answer' do
    sign_in(user)
    create_question
    click_on 'Test question'
    create_answer
    click_on 'Delete'
    expect(page).to have_content 'The answer is successfully deleted.'
  end

  scenario 'Authenticated user tries to delete not his own answer' do
    sign_in(user)
    create_question
    click_on 'Test question'
    create_answer
    visit questions_path
    click_on 'Log out'
    click_on 'Ask question'
    sign_up(user)
    visit questions_path
    click_on 'Test question'
    expect(page).to_not have_content 'Delete'
  end
end
