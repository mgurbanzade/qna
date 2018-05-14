require_relative "../acceptance_helper"

feature 'Comment question', %q{
  As an authenticated user
  I want to be able to comment a question
} do

  given!(:question) { create(:question) }

  scenario 'Authenticated user tries to create comment with valid params', js: true do
    sign_in(question.user)
    visit question_path(question)

    within '.question-comments' do
      fill_in 'Comment', with: 'text text'
      click_on 'Create Comment'
      expect(page).to have_content 'text text'
    end
  end

  scenario 'Authenticated user tries to create comment with invalid params', js: true do
    sign_in(question.user)
    visit question_path(question)

    within '.question-comments' do
      fill_in 'Comment', with: ''
      click_on 'Create Comment'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Non-authenticated user tries to create comment', js: true do
    visit question_path(question)

    within '.question-comments' do
      fill_in 'Comment', with: 'text text'
      click_on 'Create Comment'
      expect(page).to_not have_content "text text"
    end
  end

  context 'mulitple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(question.user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question-comments' do
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
