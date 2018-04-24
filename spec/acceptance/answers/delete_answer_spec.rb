require 'rails_helper'

feature 'Delete answer', %q{
  As an authenticated user
  I want to be able to delete my answers
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his answer' do
    sign_in(user)
    question = create(:question, user: user)
    answer = create(:answer, question: question, user: user)
    visit question_path(question)
    click_on 'Delete'
    expect(page).to have_content 'The answer is successfully deleted.'
    expect(page).to_not have_content 'My answer'
  end

  scenario 'Authenticated user tries to delete not his own answer' do
    question = create(:question, user: user)
    answer = create(:answer, question: question, user: user)
    user2 = create(:user)
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_content 'Delete'
  end
end
