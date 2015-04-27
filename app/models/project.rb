class Project < ActiveRecord::Base
  has_many :entries, dependent: :destroy

  validates_presence_of :title

  def self.search(query = nil)
    if query
      result = where('title ILIKE ?', "%#{query}%")
    else
      result = all
    end

    result.order(date: :desc)
  end
end
