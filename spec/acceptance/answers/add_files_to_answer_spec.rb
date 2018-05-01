require_relative "../acceptance_helper"

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I'd like to be able to attach files
} do

  given(:question) { create(:question) }

  background do
    sign_in(question.user)
    visit question_path(question)
  end

  scenario 'User adds file when responses to question', js: true do
    within '.new_answer' do
      fill_in 'Body', with: 'Answer Answer Answer'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Reply'
    end

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
