module DefenceRequestTransitions
  class Abort
    def initialize(transition_params)
      @defence_request = transition_params.fetch(:defence_request)
      @requested_transition = transition_params.fetch(:transition_to)
      @transition_info = transition_params.fetch(:transition_info)
      @user = transition_params.fetch(:user)
    end

    def complete
      set_transition_info && transition_defence_request
    end

    private

    attr_reader :defence_request, :requested_transition, :transition_info, :user

    def set_transition_info
      return true if defence_request.reason_aborted = transition_info
    end

    def transition_defence_request
      trigger_transition && defence_request.save!
    end

    def trigger_transition
      defence_request.public_send(requested_transition.to_sym)
    rescue Transitions::InvalidTransition
      return false
    end
  end
end
