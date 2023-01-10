require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

# now use the secret with a session cookie middleware use
require 'sidekiq/web'
Sidekiq::Web.use Rack::Session::Cookie, secret: File.read('.session.key'), same_site: true, max_age: 86_400

run Sidekiq::Web
