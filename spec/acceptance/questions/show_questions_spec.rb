require 'rails_helper'

feature 'Show questions', %q{
  User can see questions list
} do

  scenario 'User tries to check questions list' do
    question = create(:question)
    visit questions_path
    expect(page).to have_content question.title
  end
end
