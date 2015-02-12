class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :defence_requests

  scope :solicitors, -> { where(role: :solicitor) }

  def cso?
    self.role.to_sym == :cso
  end

  def cco?
    self.role.to_sym == :cco
  end

  def solicitor?
    self.role.to_sym == :solicitor
  end

end
