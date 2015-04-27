module DefenceRequestTransitions
  class Queue
    def initialize(transition_params)
      @defence_request = transition_params.fetch(:defence_request)
    end

    def complete
      queue_defence_request
    end

    private

    attr_reader :defence_request

    def queue_defence_request
      run_transition && defence_request.save!
    end

    def run_transition
      defence_request.can_queue? && defence_request.queue
    end
  end
end
