class User < ActiveRecord::Base
  devise :database_authenticatable, :rememberable, :validatable, :recoverable

  attr_accessor :login

  ROLES = %i( administrator manager accountant worker )

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash)
      .where(
        [
          'lower(username) = :value OR lower(email) = :value',
          { value: login.downcase }
        ]
      )
      .first
    else
      where(conditions.to_hash).first
    end
  end

  def to_s
    name.presence || username
  end

  def active_for_authentication?
    super && is_active?
  end

  ROLES.each do |r|
    define_method "#{r}?" do
      role == r.to_s
    end
  end
end
