class CcoDefenceRequestPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope.record
    end

    def resolve
      scope.not_draft
    end
  end

  attr_reader :policy_user, :policy_record

  def initialize(user, context)
    @policy_user = user
    @policy_record = context.record
  end

  def show?
    !policy_record.draft?
  end

  def edit?
    (user_is_the_assigned_cco && !policy_record.draft? && !policy_record.queued?) && !policy_record.aborted?
  end

  def update?
    edit?
  end

  def solicitor_time_of_arrival?
    policy_record.accepted? && user_is_the_assigned_cco
  end

  def solicitor_time_of_arrival_from_show?
    false
  end

  def edit_solicitor_details?
    user_is_the_assigned_cco && edit?
  end

  def add_case_time_of_arrival?
    false
  end

  def create?
    false
  end

  def interview_start_time_edit?
    false
  end

  def dscc_number_edit?
    policy_record.acknowledged? && user_is_the_assigned_cco
  end

  def acknowledge?
    policy_record.can_execute_acknowledge?
  end

  def accept?
    user_is_the_assigned_cco && policy_record.can_execute_accept?
  end

  def resend_details?
    user_is_the_assigned_cco && policy_record.accepted?
  end

  def abort?
    false
  end

  private

  def user_is_the_assigned_cco
    policy_record.cco_uid == policy_user.uid
  end
end
