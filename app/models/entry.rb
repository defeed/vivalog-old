class Entry < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project_id, :worked_on, :work_type, :coefficient

  def self.work_types
    {
      'Receiving' => 'receive',
      'Polishing' => 'polish',
      'Other' => 'other'
    }
  end
end
