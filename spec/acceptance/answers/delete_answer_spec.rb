require 'rails_helper'

feature 'Delete answer', %q{
  As an authenticated user
  I want to be able to delete my answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user deletes his answer' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete'
    expect(page).to have_content 'The answer is successfully deleted.'
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user tries to delete not his own answer' do
    user2 = create(:user)
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end

  scenario 'Non-authenticated user tries to delete an answer' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end
end
