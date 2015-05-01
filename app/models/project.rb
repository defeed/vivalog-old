class Project < ActiveRecord::Base
  has_many :entries, dependent: :destroy

  validates_presence_of :title

  has_many :payouts
  belongs_to :finalizer, class_name: 'User', foreign_key: 'finalized_by'

  scope :not_finalized, -> { where(finalized_at: nil) }
  scope :finalized, -> { where.not(finalized_at: nil) }

  def self.search(query = nil)
    if query
      result = where('title ILIKE ?', "%#{query}%")
    else
      result = all
    end

    result.order(date: :desc)
  end

  def avg_workers
    return 0 if entries.none?
    entries.map(&:workers).inject(:+).to_f / entries.count
  end

  def finalizable?
    not_finalized_reasons.none?
  end

  def not_finalized_reasons
    reasons = []
    reasons.push :no_entries if entries.none?
    reasons.push :no_date if date.blank?
    reasons.push :no_volume if volume.blank?
    reasons.push :no_price_receive if price_receive.blank?
    reasons.push :no_price_polish if price_polish.blank?
    reasons.push :workers_not_eql unless entries.count == avg_workers
    reasons.push :date_in_future if date && date > Date.today

    reasons
  end

  def finalize(user)
    return not_finalized_reasons unless finalizable?

    transaction do
      update(finalized_at: Time.now, finalizer: user)
      true
    end
  end

  def finalized?
    !!finalized_at
  end
end
