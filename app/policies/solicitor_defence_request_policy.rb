class SolicitorDefenceRequestPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope.record
    end

    def resolve
      scope.related_to_solicitor(user).accepted_aborted_or_completed
    end
  end

  attr_reader :policy_user, :policy_record

  def initialize(user, context)
    @policy_user = user
    @policy_record = context.record
  end

  def solicitor_time_of_arrival?
    user_is_the_assigned_solicitor && !policy_record.aborted?
  end

  def solicitor_time_of_arrival_from_show?
    user_is_the_assigned_solicitor && !policy_record.aborted?
  end

  def show?
    (user_is_the_assigned_solicitor || user_is_from_the_same_organisation) && !policy_record.draft?
  end

  private

  def user_is_the_assigned_solicitor
    policy_record.solicitor_uid == policy_user.uid
  end

  def user_is_from_the_same_organisation
    policy_user.organisation_uids.include?(policy_record.organisation_uid)
  end
end
