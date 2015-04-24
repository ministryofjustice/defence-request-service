class DefenceRequestPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.roles.include?("cso")
        scope.not_aborted
      elsif user.roles.include?("cco")
        scope.not_draft
      elsif user.roles.include?("solicitor")
        scope.related_to_solicitor(user).accepted_or_aborted
      else
        scope.none
      end
    end
  end

  def show?
    (cso && !record.aborted?) || ((cco  || user_is_the_assigned_solicitor) && !record.draft?)
  end

  def new?
    cso
  end

  def create?
    cso
  end

  def edit?
    ((cso && record.draft?) || (user_is_the_assigned_cco && !record.draft? && !record.queued?)) && !record.aborted?
  end

  def update?
    edit?
  end

  def solicitors_search?
    cso
  end

  def add_case_time_of_arrival?
    create? && record.new_record?
  end

  def dscc_number_edit?
    record.acknowledged? && user_is_the_assigned_cco
  end

  def interview_start_time_edit?
    cso && !record.new_record? && record.draft?
  end

  def acknowledge?
    cco && record.can_execute_acknowledge?
  end

  def accept?
    user_is_the_assigned_cco && record.can_execute_accept?
  end

  def resend_details?
    (user_is_the_assigned_cco || cso) && record.accepted?
  end

  def edit_solicitor_details?
    (record.own_solicitor? || user_is_the_assigned_cco) && edit?
  end

  def solicitor_time_of_arrival?
    (user_is_the_assigned_solicitor && !record.aborted?) || (record.accepted? && (user_is_the_assigned_cco || cso))
  end

  def solicitor_time_of_arrival_from_show?
    user_is_the_assigned_solicitor && !record.aborted?
  end

  def queue?
    cso && record.draft?
  end

  def finish?
    cso && record.can_execute_finish?
  end

  def abort?
    cso && record.can_execute_abort?
  end

  private

  def cco
    user.roles.include?("cco")
  end

  def cso
    user.roles.include?("cso")
  end

  def solicitor
    user.roles.include?("solicitor")
  end

  def user_is_the_assigned_cco
    cco && record.cco_uid == user.uid
  end

  def user_is_the_assigned_solicitor
    solicitor && record.solicitor_uid == user.uid
  end
end
