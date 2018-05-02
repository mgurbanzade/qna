require_relative "../acceptance_helper"

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of question
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'User tries to add multiple files when asks question', js: true do
    click_on 'Attach file'

    within first('.nested-fields') do
      attach_file 'File', "#{Rails.root}/app/assets/images/logo.png"
    end

    click_on 'Create'
    expect(page).to have_link 'Test question'
    click_on 'Test question'
    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'logo.png'
  end

  scenario 'User tries to delete files attached by him', js: true do
    within first('.nested-fields') do
      expect(page).to have_link 'Delete'
    end

    click_link 'Delete'
    click_on 'Create'
    expect(page).to_not have_link 'spec_helper.rb'
  end
end
