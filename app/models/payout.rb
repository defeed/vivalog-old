class Payout < ActiveRecord::Base
  belongs_to :entry
  belongs_to :project
  belongs_to :user

  validates :entry_id, :project_id, :user_id, :base_amount, :amount,
            presence: true
end
