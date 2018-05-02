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
    fill_in 'Body', with: 'Answer Answer Answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  end

  scenario 'User tries to add multiple files when creating an answer to question', js: true do
    click_on 'Attach file'

    within first('.nested-fields') do
      attach_file 'File', "#{Rails.root}/app/assets/images/logo.png"
    end

    click_on 'Reply'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'logo.png'
    end
  end

  scenario 'User tries to delete the file attached by him', js: true do
    within first('.nested-fields') do
      expect(page).to have_link 'Delete'
    end

    click_on 'Delete'
    click_on 'Reply'
    expect(page).to_not have_link 'spec_helper.rb'
  end
end
