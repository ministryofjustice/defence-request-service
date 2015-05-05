Drs::AuthClient.configure do |client|
  client.host = Settings.authentication.site_url
  client.version = :v1
end