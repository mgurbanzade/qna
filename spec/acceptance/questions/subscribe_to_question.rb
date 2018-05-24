require_relative "../acceptance_helper"

feature 'Authenticated user can subscribe and unsubscribe' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Authenticated user' do
    before { sign_in(user) }

    scenario 'tries to subscribe to question', js: true do
      visit question_path(question)

      click_on 'Subscribe'

      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'tries to unsubscribe from question', js: true do
      visit question_path(question)

      click_on 'Subscribe'
      expect(page).to_not have_link 'Subscribe'
      click_on 'Unsubscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end
