require 'rails_helper'

feature 'Question show', %q{
  User can check the question page and see its answers
} do

  given(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User tries to check the question page' do
    visit question_path(question)
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end

    expect(current_path).to eq question_path(question)
  end
end
