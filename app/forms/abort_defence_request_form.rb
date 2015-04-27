  class AbortDefenceRequestForm
    include ActiveModel::Model

    attr_accessor :transition_info

    validates :transition_info, presence: true

    def initialize(defence_request, transition = nil, attrs = {})
      @defence_request = defence_request
      @transition = transition
      @transition_info = attrs[:transition_info]
    end

    def defence_request_id
      defence_request.id
    end

    def submit
      submission_is_successful?
    end

    private

    attr_reader :defence_request, :transition

    def submission_is_successful?
      valid? && transition_completed?
    end

    def transition_completed?
      transition.complete
    end
  end
