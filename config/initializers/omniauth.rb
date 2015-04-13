Rails.application.config.middleware.use OmniAuth::Builder do
  provider :defence_request,
    Settings.authentication.application_id,
    Settings.authentication.application_secret
end
