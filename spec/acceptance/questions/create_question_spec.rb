require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answers from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question', js: true do
    sign_in(user)
    create_question
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'mytext mytext'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(current_path).to eq new_user_session_path
  end

  scenario 'Authenticated user tries to create question with incorrect attributes', js: true do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
  end
end
