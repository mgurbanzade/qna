require_relative "../acceptance_helper"

feature 'Comment question', %q{
  As an authenticated user
  I want to be able to comment an answer
} do

  given!(:answer) { create(:answer) }

  scenario 'Authenticated user tries to create comment with valid params', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    within '.answer-comments' do
      fill_in 'Comment', with: 'text text'
      click_on 'Create Comment'
      expect(page).to have_content 'text text'
    end
  end

  scenario 'Authenticated user tries to create comment with invalid params', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    within '.answer-comments' do
      fill_in 'Comment', with: ''
      click_on 'Create Comment'
      expect(page).to have_content "Body can't be blank"
    end
  end

  context 'mulitple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(answer.user)
        visit question_path(answer.question)
      end

      Capybara.using_session('guest') do
        visit question_path(answer.question)
      end

      Capybara.using_session('user') do
        within '.answer-comments' do
          fill_in 'Comment', with: 'text text'
          click_on 'Create Comment'
          expect(page).to have_content "text text"
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'text text'
      end
    end
  end
end
