module AuthClientHelper
  def mock_organisations(organisations)
    to_return = organisations.map do |organisation|
      if organisation.is_a?(Hash)
        Drs::AuthClient::Models::Organisation.new(organisation)
      else
        organisation
      end
    end

    auth_client = double(Drs::AuthClient::Client)

    allow(Drs::AuthClient::Client).to receive(:new).and_return(auth_client)
    allow(auth_client).to receive(:organisations).and_return(to_return)
  end
end