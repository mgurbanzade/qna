require_relative "../acceptance_helper"

feature 'Remove attachments from answer', %q{
  As an author of answer
  I'd like to be able to remove attached files
} do

  given!(:answer) { create(:answer) }
  given!(:attachment) { create(:attachment, attachable: answer) }
  given(:user) { create(:user) }

  scenario 'User tries to delete the attachments from his existing answer', js: true do
    sign_in(answer.user)
    visit question_path(answer.question)

    within '.answer_attachments' do
      expect(page).to have_link 'Delete attachment'
      click_on 'Delete attachment'
      expect(page).to_not have_link attachment.file
    end
  end

  scenario 'User tries to delete not his own attachments' do
    sign_in(user)
    visit question_path(answer.question)

    within '.answer_attachments' do
      expect(page).to_not have_link 'Delete attachment'
    end
  end
end
