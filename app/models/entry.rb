class Entry < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :user_id, :project_id, :worked_on, :work_type, presence: true
  validates :coefficient, :workers,
            presence: true, unless: :type_other?
  validates :hours, :hourly_rate,
            presence: true, if: :type_other?

  WORK_TYPES = %i( receive polish other )

  before_create :remove_workers_and_coefficient

  def type_other?
    work_type == 'other'
  end

  def remove_workers_and_coefficient
    return unless type_other?

    self.workers = nil
    self.coefficient = nil
  end
end
