module DefenceRequestTransitions
  class Abort
    def initialize(transition_params)
      @defence_request = transition_params.fetch(:defence_request)
      @transition_info = transition_params.fetch(:transition_info)
      @user = transition_params.fetch(:user)
    end

    def complete
      set_transition_info && abort_defence_request
    end

    private

    attr_reader :defence_request, :transition_info, :user

    def set_transition_info
      return true if defence_request.reason_aborted = transition_info
    end

    def abort_defence_request
      run_transition && defence_request.save!
    end

    def run_transition
      defence_request.can_abort? && defence_request.abort
    end
  end
end
