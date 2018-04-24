require 'rails_helper'

feature 'Question show', %q{
  User can check the question page and see its answers
} do

  given(:user) { create(:user) }

  scenario 'User tries to check the question page' do
    question = create(:question, user: user)
    answers = create_list(:answer, 3, question: question, user: user)
    visit question_path(question)
    expect(page).to have_content question.body
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
    expect(page).to have_content answers[2].body
    expect(current_path).to eq question_path(question)
  end
end
