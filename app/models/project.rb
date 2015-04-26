class Project < ActiveRecord::Base
  has_many :entries, dependent: :destroy

  validates_presence_of :title
end
