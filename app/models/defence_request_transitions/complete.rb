module DefenceRequestTransitions
  class Complete
    def initialize(transition_params)
      @defence_request = transition_params.fetch(:defence_request)
    end

    def complete
      complete_defence_request
    end

    private

    attr_reader :defence_request

    def complete_defence_request
      run_transition && defence_request.save!
    end

    def run_transition
      defence_request.can_complete? && defence_request.complete
    end
  end
end
