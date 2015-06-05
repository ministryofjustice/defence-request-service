class DefenceRequestPresenter < SimpleDelegator
  delegate :name, :tel, to: :organisation, allow_nil: true, prefix: :firm

  def initialize(client, defence_request)
    #
    # TODO: the API client should not be passed in here.
    # The organisation should be fetched before this point - the presenter is a composite object bound to a form...
    # it should not be responsible for fetching data (and not making API calls..), it should be initialized with everything it needs
    #

    super defence_request
    @client = client
  end

  def state_text
    state_class.capitalize
  end

  def state_class
    case state
      when "queued", "acknowledged"
        "submitted"
      else
        state
    end
  end

  def state_updated_time
    state_updated_at.strftime("%H:%M:%S")
  end
  alias :last_action_time :state_updated_time

  private

  attr_reader :client

  def defence_request
    __getobj__
  end

  def organisation
    @organisation ||= client.organisation(organisation_uid) if organisation_uid
  end

  def state_updated_at
    defence_request.state_updated_at || defence_request.updated_at
  end
end
