class CsoDefenceRequestPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope.record
    end

    def resolve
      scope.not_aborted.for_custody_suite(user.organisation["uid"])
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
    !policy_record.accepted? && !policy_record.aborted?
  end

  def update?
    edit?
  end

  def solicitor_time_of_arrival?
    policy_record.accepted?
  end

  def interview_start_time_edit?
    !policy_record.aborted?
  end

  def solicitor_time_of_arrival_from_show?
    false
  end

  def queue?
    policy_record.draft?
  end
end
