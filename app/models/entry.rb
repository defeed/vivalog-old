class Entry < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :user_id, :project_id, :worked_on, :work_type, :coefficient,
            presence: true

  WORK_TYPES = %i( receive polish other )
end
