require_relative '../acceptance_helper'

feature 'Edit answer', %q{
  As an authenticated user
  I want to be able to edit my answers
} do

  given(:answer) { create(:answer) }
  given(:user2) { create(:user) }

  scenario 'Non-authenticated user tries to edit an answer' do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(answer.user)
      visit question_path(answer.question)
    end

    scenario 'sees edit link' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his own answer', js: true do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'Edited answer'
        click_on 'Update'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario 'Authenticated user tries to edit not his own answer' do
    sign_in(user2)
    visit question_path(answer.question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
