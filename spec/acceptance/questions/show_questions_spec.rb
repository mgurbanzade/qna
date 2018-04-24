require 'rails_helper'

feature 'Index questions', %q{
  User can see questions list
} do

  given(:user) { create(:user) }

  scenario 'User tries to check questions list' do
    questions = create_list(:question, 3, user: user)
    visit questions_path
    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
    expect(page).to have_content questions[2].title
  end
end
