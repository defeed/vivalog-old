class Entry < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :user_id, :worked_on, :work_type, :coefficient

  def work_types
    {
      'Receiving' => 'receive',
      'Polishing' => 'polish'
    }
  end
end
