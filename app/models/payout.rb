class Payout < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :work_type,
            uniqueness: {
              scope: [:user, :project],
              message: 'Cannot pay twice for same project and work type'
            }
  validates :project_id, presence: true
  validates :user_id, presence: true
  validates :work_type, presence: true
  validates :amount, presence: true
end
