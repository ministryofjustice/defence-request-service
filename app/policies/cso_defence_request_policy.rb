class CsoDefenceRequestPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, context)
    @user = user
    @record = context.record
  end

  def show?
    !record.aborted?
  end

  def new?
    true
  end

  def create?
    true
  end

  def edit?
    (record.draft? || (user_is_the_assigned_cco && !record.draft? && !record.queued?)) && !record.aborted?
  end

  def edit_solicitor_details?
    user_is_the_assigned_cco && edit?
  end

  def solicitor_time_of_arrival?
    record.accepted? && user_is_the_assigned_cco
  end

  def add_case_time_of_arrival?
    create? && record.new_record?
  end

  private

  def user_is_the_assigned_cco
    record.cco_uid == user.uid
  end
end
