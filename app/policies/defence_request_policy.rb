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

  def refresh_dashboard?
    cso || cco || solicitor
  end

  def feedback?
    (cso || cco) && can_transition?(:close)
  end

  def close?
    (cso || cco) && can_transition?(:close)
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
    cco && can_transition?(:open)
  end

  def accept?
    cco && can_transition?(:accept) && has_dscc_number?
  end

  def accepted?
    cco && can_transition?(:accept) && has_dscc_number?
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

  def can_transition?(state)
    record.can_transition?(state)
  end

  def cso
    user.cso?
  end

  def cco
    user.cco?
  end

  def solicitor
    user.solicitor?
  end

  def has_dscc_number?
    record.dscc_number?
  end

end
