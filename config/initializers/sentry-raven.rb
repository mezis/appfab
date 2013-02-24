RAVEN_URLS = {
  'staging'    => 'https://8349a0b5980a461c8552e1ca0b39e00a:c1d41bb8cfd240479dbeaed0078cd424@app.getsentry.com/5334',
  'production' => 'https://e63cfbdf8e38470fb34511dfe06b6b36:bcc94f320b54470094fff03c09b393b7@app.getsentry.com/5355'
}

if RAVEN_URLS[Rails.env]
  require 'raven'

  Raven.configure do |config|
    config.dsn = RAVEN_URLS[Rails.env]
    config.environments = RAVEN_URLS.keys
  end
end
