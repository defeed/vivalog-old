class Entry < ActiveRecord::Base
  belongs_to :project

  validates_presense_of :user_id, :worked_on, :work_type, :coefficient

  def work_types
    {
      'Receiving' => 'receive',
      'Polishing' => 'polish'
    }
  end
end
