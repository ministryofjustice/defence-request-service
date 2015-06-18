class ServiceUser < SimpleDelegator
  ALLOWED_ORGANISATION_TYPES = %w(custody_suite)

  attr_reader :organisation

  def self.from_omniauth_user(user)
    new(user) unless user.nil?
  end

  def roles
    return [] unless @organisation

    @organisation["roles"]
  end

  private

  def initialize(user)
    @user = user
    select_organisation

    super
  end

  def select_organisation
    # for the moment we find first allowed organisation
    @organisation = @user.organisations.find { |o| ALLOWED_ORGANISATION_TYPES.include?(o["type"]) }
  end
end
