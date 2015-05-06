module MockAuthApiHelper
  def mock_auth_api_client
    @old_service = ServiceRegistry.service(:auth_api_client)
    MockClient.reset_mock
    ServiceRegistry.register(:auth_api_client, MockClient)
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

    def organisations(params = {})
      self.class.mocked_organisations
    end

    def self.reset_mock
      @mocked_organisations = []
    end

    def self.mock_organisations(organisations)
      @mocked_organisations = organisations.map do |organisation|
        if organisation.is_a?(Hash)
          Drs::AuthClient::Models::Organisation.new(organisation)
        else
          organisation
        end
      end
    end

    def self.mocked_organisations
      @mocked_organisations ||= []
    end
  end
end

RSpec.configure do |config|
  config.include MockAuthApiHelper, mock_auth_api: true

  config.around(:each, mock_auth_api: true) do |example|
    mock_auth_api_client
    example.run
    clean_auth_api_client_mock
  end

end
