class SolicitorDefenceRequestPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, context)
    @user = user
    @record = context.record
  end

  def solicitor_time_of_arrival?
    user_is_the_assigned_solicitor && !record.aborted?
  end

  def solicitor_time_of_arrival_from_show?
    user_is_the_assigned_solicitor && !record.aborted?
  end

  def show?
    user_is_the_assigned_solicitor && !record.draft?
  end

  private

  def user_is_the_assigned_solicitor
    record.solicitor_uid == user.uid
  end
end
