require 'rails_helper'

feature 'Show questions', %q{
  User can see questions list
} do

  given(:user) { create(:user) }

  scenario 'User tries to check questions list' do
    question = create(:question, user: user)
    visit questions_path
    expect(page).to have_content question.title
  end
end
