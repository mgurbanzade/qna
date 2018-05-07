require_relative "../acceptance_helper"

feature 'Answer rating', %q{
  As an authenticated user
  I want to be able to vote for
  or against an answer and see its rating
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:answer) { create(:answer, user: user2) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
    end

    scenario 'authenticated user tries to like not his own answer', js: true do
      visit question_path(answer.question)

      within ".rate_answer_#{answer.id}" do
        click_on 'Like'
        expect(page).to have_link 'Unvote'

        within '.current_rating' do
          expect(page).to have_content '+1'
        end
      end
    end

    scenario 'authenticated user tries to dislike not his own answer', js: true do
      visit question_path(answer.question)

      within ".rate_answer_#{answer.id}" do
        click_on 'Dislike'
        expect(page).to have_link 'Unvote'

        within '.current_rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'authenticated user tries to unvote after like', js: true do
      visit question_path(answer.question)

      within ".rate_answer_#{answer.id}" do
        click_on 'Like'
        click_on 'Unvote'

        within '.current_rating' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'authenticated user tries to unvote after dislike', js: true do
      visit question_path(answer.question)

      within ".rate_answer_#{answer.id}" do
        click_on 'Dislike'
        click_on 'Unvote'

        within '.current_rating' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'authenticated user tries to vote for his own answer' do
      click_on 'Log out'
      sign_in(user2)
      visit question_path(answer.question)

      within ".rate_answer_#{answer.id}" do
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
        expect(page).to_not have_link 'Unvote'
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Non-authenticated user' do
    scenario 'tries to vote for an answer' do
      visit question_path(answer.question)

      within ".rate_answer_#{answer.id}" do
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
        expect(page).to_not have_link 'Unvote'
        expect(page).to have_content '0'
      end
    end
  end
end
