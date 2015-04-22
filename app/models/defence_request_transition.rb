class DefenceRequestTransition
  def initialize(defence_request, requested_transition, user)
    @defence_request = defence_request
    @requested_transition = requested_transition
    @user = user
  end

  def complete
    if transitioning_to_acknowledge?
      set_cco && transition_defence_request
    else
      transition_defence_request
    end
  end

  private

  attr_reader :defence_request, :requested_transition, :user

  def transitioning_to_acknowledge?
    requested_transition == "acknowledge"
  end

  def transition_defence_request
    trigger_transition && defence_request.save!
  end

  def trigger_transition
    defence_request.public_send(requested_transition.to_sym)
  rescue Transitions::InvalidTransition
    return false
  end

  def set_cco
    defence_request.cco = user
  end
end
