require_relative '../acceptance_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to response to questions
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(question.user)
    visit question_path(question)
    create_answer

    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'Authenticated user tries to create answer with incorrect attributes', js: true do
    sign_in(question.user)
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Reply'
    expect(page).to have_content "Body can't be blank"
  end

  context "mulitple sessions" do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        create_answer
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'My answer'
      end
    end
  end
end
