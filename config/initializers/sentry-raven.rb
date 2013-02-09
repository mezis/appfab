require 'raven'

Raven.configure do |config|
  config.dsn = 'https://8349a0b5980a461c8552e1ca0b39e00a:c1d41bb8cfd240479dbeaed0078cd424@app.getsentry.com/5334'
  config.environments = %w[development staging production]
end
