module DefenceRequestTransitions
  class Accept
    def initialize(transition_params)
      @defence_request = transition_params.fetch(:defence_request)
      @requested_transition = transition_params.fetch(:transition_to)
    end

    def complete
      ActiveRecord::Base.transaction { transition_defence_request }
    end

    private

    attr_reader :defence_request, :requested_transition, :user

    def set_cco
      defence_request.cco = user
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
