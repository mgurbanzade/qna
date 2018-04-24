require 'rails_helper'

feature 'Delete answer', %q{
  As an authenticated user
  I want to be able to delete my answers
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his answer' do
    sign_in(user)
    create_question
    click_on 'Test question'
    fill_in 'Body', with: 'Random answer'
    click_on 'Reply'
    click_on 'Delete'
    expect(page).to have_content 'The answer is successfully deleted.'
  end
end
