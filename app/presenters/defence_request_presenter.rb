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

  def queued_at_time
    created_at.strftime("%H:%M:%S")
  end
  alias :submitted_time :queued_at_time
  alias :accepted_time :queued_at_time
  alias :completed_time :queued_at_time
  alias :closed_time :completed_time
  alias :aborted_time :completed_time

  def last_action_time
    send "#{state_class}_time"
  end

  private

  attr_reader :client

  def organisation
    @organisation ||= client.organisation(organisation_uid) if organisation_uid
  end
end
