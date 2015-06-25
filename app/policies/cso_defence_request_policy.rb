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
    scoped?
  end

  def new?
    true
  end

  def create?
    belongs_to_custody_suite?
  end

  def edit?
    scoped?
  end

  def update?
    edit?
  end

  def interview_start_time_edit?
    scoped?
  end

  def queue?
    scoped? && policy_record.draft?
  end

  private

  def scoped?
    !policy_record.aborted? &&
      belongs_to_custody_suite?
  end

  def belongs_to_custody_suite?
    custody_suite_uid = policy_user.organisation["uid"]
    policy_record.custody_suite_uid == custody_suite_uid
  end


end
