OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  setup = ->(env) do
    options = GithubAuthOptions.new(env)
    env["omniauth.strategy"].options.merge!(options.to_hash)
    env["omniauth.strategy"].options[:client_options] =  {
      :site => Hound::GITHUB_URL + '/api/v3',
      :authorize_url => Hound::GITHUB_URL + '/login/oauth/authorize',
      :token_url => Hound:: GITHUB_URL + '/login/oauth/access_token'
    }
  end

  provider(
    :github,
    ENV['GITHUB_CLIENT_ID'],
    ENV['GITHUB_CLIENT_SECRET'],
    setup: setup
  )
end
