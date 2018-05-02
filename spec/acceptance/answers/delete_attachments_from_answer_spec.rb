require_relative "../acceptance_helper"

feature 'Remove attachments from answer', %q{
  As an author of answer
  I'd like to be able to remove attached files
} do

  given!(:question) { create(:question) }
  given!(:user) { create(:user) }

  background do
    sign_in(question.user)
    visit question_path(question)
    within '.new_answer' do
      fill_in 'Body', with: 'Answer Answer Answer'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Reply'
    end
  end

  scenario 'User tries to delete the attachments from his existing answer', js: true do
    within '.answer_attachments' do
      expect(page).to have_link 'Delete attachment'
      click_on 'Delete attachment'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  scenario 'User tries to delete not his own attachments', js: true do
    click_on 'Log out'
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'Delete attachment'
  end
end
