module DefenceRequestTransitions
  class Builder
    def initialize(transition_params)
      @transition_params = transition_params
    end

    def build
      build_transition_strategy
    end

    private

    attr_reader :transition_params

    def build_transition_strategy
      strategy.new(transition_params)
    end

    def strategy
      "DefenceRequestTransitions::#{requested_transition.classify}".constantize
    end

    def requested_transition
      transition_params.fetch(:transition_to)
    end
  end
end
