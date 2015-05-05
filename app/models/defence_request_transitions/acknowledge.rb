module DefenceRequestTransitions
  class Acknowledge
    def initialize(transition_params)
      @defence_request = transition_params.fetch(:defence_request)
      @user = transition_params.fetch(:user)
    end

    def complete
      set_cco && acknowledge_defence_request
    end

    private

    attr_reader :defence_request, :user

    def set_cco
      return true if defence_request.cco_uid = user.uid
    end

    def acknowledge_defence_request
      run_transition && defence_request.save! && defence_request.generate_dscc_number!
    end

    def run_transition
      defence_request.can_acknowledge? && defence_request.acknowledge
    end
  end
end
