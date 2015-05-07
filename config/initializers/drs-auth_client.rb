Drs::AuthClient.configure do |client|
  client.host = Settings.authentication.site_url
  client.version = :v1
end

ServiceRegistry.register(:auth_api_client, Drs::AuthClient::Client)
