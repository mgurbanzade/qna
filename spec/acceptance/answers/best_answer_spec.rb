require_relative '../acceptance_helper'

feature 'Best answer', %q{
  As an authenticated user
  I want to be able to choose best answer for my question
} do

  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:best_answer) { create(:answer, question: question, best: true) }
  given(:user2) { create(:user) }

  scenario 'Non authenticated user tries to choose best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark as best'
    expect(page).to_not have_link 'Remove best flag'
  end

  describe 'Authenticated user tries to', js: true do
    before do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario 'choose best answer for his question' do
      within ".answer_#{answer.id}" do
        click_on 'Mark as best'
        expect(page).to_not have_link 'Mark as best'
        expect(page).to have_link 'Remove best flag'
      end
    end
  end

  describe 'Authenticated user tries to', js: true do
    before do
      sign_in(question.user)
      best_answer
      visit question_path(question)
      @best_link_title = 'Remove best flag'
      @link_title = 'Mark as best'
    end

    scenario 'mark another answer as the best' do
      within ".answers" do
        within ".answer_#{best_answer.id}" do
          expect(page).to have_link @best_link_title
        end

        within ".answer_#{answer.id}" do
          expect(page).to have_link @link_title
          click_on @link_title
        end

        within ".answer_#{best_answer.id}" do
          expect(page).to_not have_link @best_link_title
          expect(page).to have_link @link_title
        end

        within ".answer_#{answer.id}" do
          expect(page).to_not have_link @link_title
          expect(page).to have_link @best_link_title
        end
      end
    end

    scenario 'remove best answer flag from his question' do
      within ".answer_#{best_answer.id}" do
        expect(page).to have_link @best_link_title
        click_on @best_link_title
        expect(page).to_not have_link @best_link_title
        expect(page).to have_link @link_title
      end
    end
  end

  describe 'Authenticated user tries to', js: true do
    before do
      best_answer
      sign_in(user2)
      visit question_path(question)
    end

    scenario 'remove best answer flag not from his question' do
      expect(page).to_not have_link 'Remove best flag'
    end

    scenario 'choose best answer not for his question' do
      expect(page).to_not have_link 'Mark as best'
    end
  end
end
