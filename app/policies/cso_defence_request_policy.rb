class CsoDefenceRequestPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope.record
    end

    def resolve
      scope.not_aborted
    end
  end

  attr_reader :policy_user, :policy_record

  def initialize(user, context)
    @policy_user = user
    @policy_record = context.record
  end

  def show?
    !policy_record.aborted?
  end

  def new?
    true
  end

  def create?
    true
  end

  def edit?
    policy_record.draft? && !policy_record.aborted?
  end

  def update?
    edit?
  end

  def solicitor_time_of_arrival?
    policy_record.accepted?
  end

  def add_case_time_of_arrival?
    create? && policy_record.new_record?
  end

  def interview_start_time_edit?
    !policy_record.aborted?
  end

  def solicitor_time_of_arrival_from_show?
    false
  end

  def dscc_number_edit?
    false
  end

  def abort?
    policy_record.can_execute_abort?
  end

  def resend_details?
    policy_record.accepted?
  end

  def queue?
    policy_record.draft?
  end

  def complete?
    policy_record.can_execute_complete?
  end

  private

  def user_is_the_assigned_cco
    policy_record.cco_uid == policy_user.uid
  end
end
