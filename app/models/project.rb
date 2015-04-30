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

  def avg_workers
    entries.map(&:workers).inject(:+).to_f / entries.count
  end

  def finalize
    return [false, :no_entries] if entries.none?
    return [false, :workers_not_eql] unless entries.count == avg_workers
    return [false, :date_in_future] if date > Date.today
    # TODO: implement stuff
    true
  end
end
