require_relative '../acceptance_helper'

feature 'Edit question', %q{
  As an authenticated user
  I want to be able to edit my questions
} do

  given(:question) { create(:question) }
  given(:user2) { create(:user) }

  scenario 'Non-authenticated user tries to edit a question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    before do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario 'sees edit link' do
      within '.question' do
        expect(page).to have_link 'Edit question'
      end
    end

    scenario 'tries to edit his question', js: true do
      click_on 'Edit question'

      within '.question_edit-form' do
        fill_in 'Title', with: 'Edited title'
        fill_in 'Body', with: 'Edited body'
        click_on 'Update'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
        expect(page).to_not have_selector "input[type=text]"
        expect(page).to_not have_selector "textarea"
      end
    end
  end

  scenario 'Authenticated user tries to edit not his own question' do
    sign_in(user2)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit question'
    end
  end
end
