require_relative '../acceptance_helper'

feature 'Delete answer', %q{
  As an authenticated user
  I want to be able to delete my answers
} do

  given!(:answer) { create(:answer) }
  given(:user2) { create(:user) }

  scenario 'Authenticated user deletes his answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    within ".answer_#{answer.id}" do
      click_on 'Delete'
    end

    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user tries to delete not his own answer' do
    sign_in(user2)
    visit question_path(answer.question)

    within ".answer_#{answer.id}" do
      expect(page).to_not have_content 'Delete'
    end
  end

  scenario 'Non-authenticated user tries to delete an answer' do
    visit question_path(answer.question)

    within ".answer_#{answer.id}" do
      expect(page).to_not have_content 'Delete'
    end
  end
end
