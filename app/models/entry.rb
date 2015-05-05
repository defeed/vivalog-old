class Entry < ActiveRecord::Base
  attr_accessor :multiple_days
  attr_accessor :final_date

  belongs_to :project
  belongs_to :user
  has_one :payout

  validates :user_id, :project_id, :worked_on, :work_type, presence: true
  validates :coefficient, :workers,
            presence: true, unless: :type_other?
  validates :hours, :hourly_rate,
            presence: true, if: :type_other?

  WORK_TYPES = %i( receive polish other )
  BILLING_TYPES  = %i( fixed_hourly fixed_daily fixed_project )

  before_create :remove_workers_and_coefficient

  scope :with_type, ->(work_type) { where(work_type: work_type)}

  def work_type_other?
    work_type == 'other'
  end

  def billed_hourly?
    billing_type == 'hourly_rate'
  end

  def remove_workers_and_coefficient
    return unless type_other?

    self.workers = nil
    self.coefficient = nil
  end
end
