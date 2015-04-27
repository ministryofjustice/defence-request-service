module DefenceRequestTransitions
  class Accept
    def initialize(transition_params)
      @defence_request = transition_params.fetch(:defence_request)
      @user = transition_params.fetch(:user)
    end

    def complete
      set_cco && accept_defence_request
    end

    private

    attr_reader :defence_request, :user

    def set_cco
      return true if defence_request.cco_uid = user.uid
    end

    def accept_defence_request
      run_transition && defence_request.save!
    end

    def run_transition
      defence_request.can_accept? && defence_request.accept
    end
  end
end
