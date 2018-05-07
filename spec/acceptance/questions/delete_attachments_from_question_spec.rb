require_relative "../acceptance_helper"

feature 'Remove attachments from question', %q{
  As an author of question
  I'd like to be able to remove attached files
} do

  given!(:question) { create(:question) }
  given(:random_user) { create(:user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'User tries to delete the attachments from his existing answer', js: true do
    sign_in(question.user)
    visit question_path(question)

    within '.question_attachments' do
      expect(page).to have_link 'Delete attachment'
      click_on 'Delete attachment'
      expect(page).to_not have_link attachment.file
    end
  end

  scenario 'User tries to delete not his own attachments' do
    sign_in(random_user)
    visit question_path(question)

    within '.question_attachments' do
      expect(page).to_not have_link 'Delete attachment'
    end
  end
end
