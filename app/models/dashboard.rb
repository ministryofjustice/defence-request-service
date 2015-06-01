class Dashboard
  def initialize(user, defence_requests_scoped_by_policy, client)
    @user = user
    @client = client
    @defence_requests_scoped_by_policy = defence_requests_scoped_by_policy
  end

  def set_visibility!(visibility)
    @visibility = visibility
  end

  def visible_requests
    case @visibility
      when :active
        active_defence_requests
      when :closed
        closed_defence_requests
      else
        active_defence_requests
    end
  end

  def defence_requests
    ordered_defence_requests
  end

  def user_role
    user.roles.uniq.first
  end

  def active_defence_requests
    @active_defence_requests ||= defence_requests.select(&:active?)
  end

  def closed_defence_requests
    @closed_defence_requests ||= defence_requests.select(&:closed?)
  end

  private

  attr_reader :user, :defence_requests_scoped_by_policy

  def ordered_defence_requests
    defence_requests_scoped_by_policy.ordered_by_created_at.map { |d| new_dash_dr[d] }
  end

  def new_dash_dr
    @new_dash_dr ||= DefenceRequestPresenter.method(:new).curry(2)[@client]
  end

  class DefenceRequestPresenter < SimpleDelegator
    delegate :name, :tel, to: :@organisation, allow_nil: true, prefix: :firm

    def initialize(client, dr)
      super dr
      @organisation = client.organisation(dr.organisation_uid) if dr.organisation_uid
    end

    def state_text
      state_class.capitalize
    end

    def state_class
      case state
        when "draft"
          "draft"
        when "queued", "acknowledged"
          "submitted"
        else
          state
      end
    end
  end
end
