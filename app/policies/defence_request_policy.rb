class DefenceRequestPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.cso?
        scope.all
      elsif user.cco?
        scope.all
      elsif user.solicitor?
        scope.has_solicitor(user)
      end
    end
  end

  def index?
    cso || cco || solicitor
  end

  def refresh_dashboard?
    index?
  end

  def show?
    cso || cco || solicitor
  end

  def new?
    cso
  end

  def create?
    cso
  end

  def edit?
    cso || (record.cco == user)
  end

  def update?
    edit?
  end

  def solicitors_search?
    cso
  end

  def feedback?
    (cso || cco) && record.can_execute_close?
  end

  def close?
    (cso || cco) && record.can_execute_close?
  end

  def dscc_number_edit?
    cco && record.opened?
  end

  def interview_start_time_edit?
    cso && !record.new_record? && record.created?
  end

  def case_details_edit?
    cso || (cco && !record.created?)
  end

  def detainee_details_edit?
    cso || (cco && !record.created?)
  end

  def solicitor_details_edit?
   (cso || cco)
  end

  def open?
    cco && record.can_execute_open?
  end

  def accept?

  def accepted?
    cco && can_transition?(:accept) && has_dscc_number?
    cco && record.can_execute_accept?
  end

  def view_open_requests?
    cco || cso
  end

  def view_created_requests?
    cco || cso
  end

  def view_accepted_requests?
    cco || cso || solicitor
  end

  def resend_details?
    (cco || cso) && record.accepted?
  end

  def solicitor_time_of_arrival?
    record.solicitor == user || (record.accepted? && (cco || cso))
  end

  def solicitor_time_of_arrival_from_show?
    record.solicitor == user
  end

  private

  def cso
    user.cso?
  end

  def cco
    user.cco?
  end

  def solicitor
    user.solicitor?
  end

end
