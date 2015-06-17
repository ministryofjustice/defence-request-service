class ServiceUser < SimpleDelegator
  ALLOWED_ORGANISATION_TYPES = %w(custody_suite)

  attr_reader :roles

  def self.from_omniauth_user(user)
    new(user) unless user.nil?
  end

  private

  def initialize(user)
    @user = user
    process_roles

    super
  end

  def process_roles
    # for the moment we find first allowed organisation and use its roles
    organisation = @user.organisations.find { |o| ALLOWED_ORGANISATION_TYPES.include?(o["type"]) }

    @roles = organisation ? organisation["roles"] : []
  end
end
