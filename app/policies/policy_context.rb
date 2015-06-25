class PolicyContext
  attr_reader :record

  def initialize(record, user)
    @record = record
    @user = user
  end

  def policy_class
    "#{@user.role}DefenceRequestPolicy".classify
  end
end
