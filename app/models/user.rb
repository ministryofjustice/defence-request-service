class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  def cso?
    self.role.to_sym == :cso
  end

  def cco?
    self.role.to_sym == :cco
  end

end
