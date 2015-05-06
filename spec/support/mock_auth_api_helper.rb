module MockAuthApiHelper
  MockAuthApiNotSetup = Class.new(Exception)

  def mock_auth_api_client(setup)
    @old_service = ServiceRegistry.service(:auth_api_client)
    ServiceRegistry.register(:auth_api_client, MockClient)

    MockClient.setup_mock(setup)
  end

  def clean_auth_api_client_mock
    ServiceRegistry.register(:auth_api_client, @old_service)
  end

  def mock_auth_api_organisations(organisations)
    MockClient.mock_organisations(organisations)
  end

  class MockClient
    def initialize(token)
    end

    [:organisations, :profiles].each do |resource|
      define_method(resource) do |params|
        calls = self.class.calls

        if calls[resource] && calls[resource][params]
          calls[resource][params]
        else
          raise MockAuthApiNotSetup.new("#{resource} with #{params} is not setup")
        end
      end
    end

    def self.calls
      @calls ||= []
    end

    def self.setup_mock(calls)
      @calls = calls
    end
  end
end

RSpec.configure do |config|
  config.include MockAuthApiHelper, mock_auth_api: true

  config.around(:each, mock_auth_api: true) do |example|
    mock_auth_api_client(auth_api_mock_setup)
    example.run
    clean_auth_api_client_mock
  end

end
