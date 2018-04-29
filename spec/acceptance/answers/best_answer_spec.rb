require_relative '../acceptance_helper'

feature 'Best answer', %q{
  As an authenticated user
  I want to be able to choose best answer for my question
} do

  given(:question) { create(:question) }

  scenario 'Non authenticated user tries to choose best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Best answer'
  end

  describe 'Authenticated user tries to' do
    scenario 'choose best answer for his question' do
      sign_in(question.user)
      click_on 'Best Answer'
    end

    scenario 'mark another answer as the best'
    scenario 'choose best answer not for his question'
    scenario 'remove best answer flag from his question'
    scenario 'remove best answer flag not from his question'
  end

  scenario 'only one answer can be marked as the best'
end
