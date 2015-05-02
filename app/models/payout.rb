class Payout < ActiveRecord::Base
  belongs_to :entry
  belongs_to :project
  belongs_to :user

  validates :entry_id, :project_id, :user_id, :amount, presence: true
  validates :base_amount, presence: true, if: :needs_base_amount?

  def needs_base_amount?
    !entry.type_other?
  end
end
