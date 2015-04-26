class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable,
         :validatable, :recoverable

  def to_s
    name.presence || username
  end
end
