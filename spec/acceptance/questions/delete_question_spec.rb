require 'rails_helper'

feature 'Delete answer', %q{
  As an authenticated user
  I want to be able to delete my questions
} do

  given(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  scenario 'Authenticated user deletes his question' do
    sign_in(user)
    create_question
    click_on 'Delete'
    expect(page).to have_content 'The question is successfully deleted.'
  end
end
