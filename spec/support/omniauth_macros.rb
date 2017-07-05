module OmniauthMacros
  def mock_auth_hash_twitter
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        'provider' => 'twitter',
        'uid' => '123545',
        'credentials' => {
            'token' => 'mock_token',
            'secret' => 'mock_secret'
        }
    })
  end

  def mock_auth_hash_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        'provider' => 'facebook',
        'uid' => '123545',
        'info' => {
            'email' => 'facebook@mail.ru'
        },
        'credentials' => {
            'token' => 'mock_token',
            'secret' => 'mock_secret'
        }
    })
  end
end
