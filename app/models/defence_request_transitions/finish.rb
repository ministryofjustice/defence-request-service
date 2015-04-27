module DefenceRequestTransitions
  class Finish
    def initialize(transition_params)
      @defence_request = transition_params.fetch(:defence_request)
    end

    def complete
      finish_defence_request
    end

    private

    attr_reader :defence_request

    def finish_defence_request
      run_transition && defence_request.save!
    end

    def run_transition
      defence_request.can_finish? && defence_request.finish
    end
  end
end
