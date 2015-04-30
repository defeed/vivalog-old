class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :validatable, :recoverable

  ROLES = %i( administrator manager accountant worker )

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  def to_s
    name
  end

  def active_for_authentication?
    super && is_active?
  end

  ROLES.each do |r|
    define_method "#{r}?" do
      role == r.to_s
    end
  end

  protected

  def password_required?
    persisted?
  end
end
