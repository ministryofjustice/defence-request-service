module DefenceRequestTransitions
  class Acknowledge
    def initialize(transition_params)
      @defence_request = transition_params.fetch(:defence_request)
      @user = transition_params.fetch(:user)
      @auth_token = transition_params.fetch(:auth_token)
    end

    def complete
      set_cco && acknowledge_defence_request
    end

    private

    attr_reader :defence_request, :user

    def set_cco
      return true if defence_request.cco_uid = user.uid
    end

    # This is a temporary way of assigning "the first available law firm",
    # later the rota service will provide organisation_uid and it'll be
    # assigned using a delayed job of some sort
    def set_organisation_uid
      client = ServiceRegistry.service(:auth_api_client).new(@auth_token)
      organisations = client.organisations(types: [:law_firm])

      if organisations.empty?
        false
      else
        defence_request.organisation_uid = organisations.first.uid
        true
      end
    end

    # Note: In the unlikely event that we cannot generate a dscc_number the dr
    # is going to end up in a broken state. We will move this into a delayed
    # job where we will handle this case.
    def acknowledge_defence_request
      run_transition && defence_request.save! && defence_request.generate_dscc_number! && set_organisation_uid
    end

    def run_transition
      defence_request.can_acknowledge? && defence_request.acknowledge
    end
  end
end
