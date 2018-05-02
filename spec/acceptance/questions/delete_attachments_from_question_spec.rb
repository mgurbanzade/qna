require_relative "../acceptance_helper"

feature 'Remove attachments from question', %q{
  As an author of question
  I'd like to be able to remove attached files
} do

  given(:user) { create(:user) }
  given(:random_user) { create(:user) }

  before do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'
  end

  scenario 'User tries to delete the attachments from his existing answer', js: true do
    click_on 'Test question'

    within '.question_attachments' do
      expect(page).to have_link 'Delete attachment'
      click_on 'Delete attachment'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end

  scenario 'User tries to delete not his own attachments', js: true do
    click_on 'Log out'
    sign_in(random_user)
    click_link 'Test question'

    within '.question_attachments' do
      expect(page).to_not have_link 'Delete attachment'
    end
  end
end
