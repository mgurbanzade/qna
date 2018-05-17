require_relative "../acceptance_helper"

feature 'Sign in from social networks', %{
  I wanna be able to sign up and sign in from
  my social network accounts
} do


  let(:user) { create(:user) }

  scenario 'User tries to sign in from vkontakte', js: true do
    auth = mock_auth_hash(:vkontakte)
    create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
    visit new_user_session_path
    expect(page).to have_content('Sign in with Vkontakte')
    click_on 'Sign in with Vkontakte'

    expect(page).to have_content('Successfully authenticated from Vkontakte account.')
  end

  scenario 'User tries to sign in from twitter', js: true do
    auth = mock_auth_hash(:twitter)
    create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
    visit new_user_session_path
    expect(page).to have_content('Sign in with Twitter')
    click_on 'Sign in with Twitter'

    expect(page).to have_content('Successfully authenticated from Twitter account.')
  end
end
