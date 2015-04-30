class Entry < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project_id, :worked_on, :work_type, :coefficient

  WORK_TYPES = %i( receive polish other )
end
