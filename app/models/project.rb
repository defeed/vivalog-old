class Project < ActiveRecord::Base
  has_many :entries

  validates_presence_of :title
end
