class Entry < ActiveRecord::Base
  attr_accessor :multiple_days
  attr_accessor :final_date

  belongs_to :project
  belongs_to :user
  has_one :payout
  belongs_to :finalizer, class_name: 'User', foreign_key: 'finalized_by'

  validates :user_id, :project_id, :worked_on, :work_type, presence: true
  validates :coefficient, :workers, presence: true, unless: :work_type_other?
  validates :hours, :hourly_rate, presence: true, if: :billed_hourly?
  validates :daily_rate, presence: true, if: :billed_daily?
  validates :project_rate, :final_date, presence: true, if: :billed_by_project?
  validates :billing_type, presence: true, if: :work_type_other?

  WORK_TYPES = %i( receive polish other )
  BILLING_TYPES  = %i( hourly_rate daily_rate project_rate )

  before_create :clear_fields

  scope :with_type, ->(work_type) { where(work_type: work_type)}

  def work_type_other?
    work_type == 'other'
  end

  def billed_hourly?
    billing_type == 'hourly_rate'
  end

  def billed_daily?
    billing_type == 'daily_rate'
  end

  def billed_by_project?
    billing_type == 'project_rate'
  end

  def clear_fields
    if work_type_other?
      self.workers = nil
      self.coefficient = nil
    else
      self.hours = nil
      self.hourly_rate = nil
      self.daily_rate = nil
      self.project_rate = nil
    end
  end

  def finalize(user)
    transaction do
      update(finalized_at: Time.now, finalizer: user)
      true
    end
  end

  def finalized?
    !!finalized_at
  end
end
