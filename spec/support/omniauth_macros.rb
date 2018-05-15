module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider.to_s,
      uid: '123545',
      info: {
        email: 'test-user@example.com'
      }
    )
  end
end
