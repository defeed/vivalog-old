class Project < ActiveRecord::Base
  validates_presence_of :title

  has_many :entries, dependent: :destroy
  has_many :workers, -> { uniq }, source: :user, through: :entries
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

  def avg_workers_for(work_type)
    entries_with_type = entries.with_type(work_type)
    return 0 if entries_with_type.none?
    entries_with_type.map(&:workers).inject(:+).to_f / entries_with_type.count
  end

  def finalizable?
    not_finalized_reasons.none?
  end

  def not_finalized_reasons
    reasons = []
    reasons.push :no_entries if entries.none?
    reasons.push :no_date if date.blank?
    reasons.push :no_volume if volume.blank?
    reasons.push :no_rate_receive if rate_receive.blank?
    reasons.push :no_rate_polish if rate_polish.blank?
    reasons.push :workers_receive_not_eql unless begin
      entries.with_type(:receive).count == avg_workers_for(:receive)
    end
    reasons.push :workers_polish_not_eql unless begin
      entries.with_type(:polish).count == avg_workers_for(:polish)
    end
    reasons.push :date_in_future if date && date > Date.today

    reasons
  end

  def finalize(user)
    return not_finalized_reasons unless finalizable?

    transaction do
      create_payouts
      update(finalized_at: Time.now, finalizer: user)
      true
    end
  end

  def create_payouts
    transaction do
      create_payouts_for_fixed_work
      create_payouts_for_hourly_work
    end
  end

  def create_payouts_for_fixed_work
    transaction do
      %w( receive polish ).each do |work_type|
        project_entries = entries.where(work_type: work_type)
        base_coeff = project_entries.map(&:coefficient).inject(:+).to_f
        base_rate = send("rate_#{work_type}") / base_coeff

        project_entries.each do |entry|
          entry.create_payout!(
            project: self,
            user: entry.user,
            amount: base_rate * entry.coefficient
          )
        end
      end
    end
  end

  def create_payouts_for_hourly_work
    transaction do
      project_entries = entries.where(work_type: :other)

      project_entries.each do |entry|
        entry.create_payout!(
          project: self,
          user: entry.user,
          amount: entry.hourly_rate * entry.hours
        )
      end
    end
  end

  def finalized?
    !!finalized_at
  end
end
