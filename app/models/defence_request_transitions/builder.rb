module DefenceRequestTransitions
  class Builder
    def initialize(transition_params)
      @requested_transition = transition_params.delete(:transition_to)
      @transition_params = transition_params
    end

    def build
      build_transition_strategy
    end

    private

    attr_reader :transition_params, :requested_transition

    def build_transition_strategy
      strategy.new(transition_params)
    end

    def strategy
      "DefenceRequestTransitions::#{requested_transition.classify}".constantize
    end
  end
end
