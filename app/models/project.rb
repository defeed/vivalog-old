class Project < ActiveRecord::Base
  validates_presence_of :title
  validate :ensure_correct_dates

  has_many :entries, dependent: :destroy
  has_many :workers, -> { uniq }, source: :user, through: :entries
  has_many :payouts
  belongs_to :finalizer, class_name: 'User', foreign_key: 'finalized_by'

  scope :not_finalized, -> { where(finalized_at: nil) }
  scope :finalized, -> { where.not(finalized_at: nil) }

  before_save :strip_title, :assign_code

  def self.search(query = nil)
    if query
      result = where('title ILIKE ? OR code ILIKE ?', "%#{query}%", "%#{query}%")
    else
      result = all
    end

    result.order(start_on: :desc)
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
    reasons.push :no_start_date if start_on.blank?
    reasons.push :no_end_date if end_on.blank?
    reasons.push :no_volume if volume.blank?
    reasons.push :no_price_receive if price_receive.blank?
    reasons.push :no_price_polish if price_polish.blank?
    reasons.push :workers_receive_not_eql unless begin
      entries.with_type(:receive).count == avg_workers_for(:receive)
    end
    reasons.push :workers_polish_not_eql unless begin
      entries.with_type(:polish).count == avg_workers_for(:polish)
    end
    reasons.push :start_date_in_future if start_on && start_on > Date.today
    reasons.push :start_date_after_end_date if begin
      start_on && end_on && start_on > end_on
    end

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
        base_amount = send("price_#{work_type}") / base_coeff

        project_entries.each do |entry|
          entry.create_payout!(
            project: self,
            user: entry.user,
            base_amount: base_amount,
            amount: base_amount * entry.coefficient
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

  def ensure_correct_dates
    return true unless start_on && end_on
    return true unless end_on
    return true if end_on >= start_on

    errors.add(:start_on, 'must start on same day or before end')
    errors.add(:end_on, 'must end on same day or after start')
  end

  def self.generate_code(title, id)
    return if title.blank?
    normalized = title
                  .to_slug
                  .normalize(transliterations: [:russian, :latin])
                  .to_s
                  .upcase
    letters = normalized.gsub(/[0-9-]/i, '').slice(0, 4).presence
    letters ||= ('A'..'Z').to_a.shuffle.take(4).join()
    numbers = title.gsub(/([0-9])/).to_a.take(2).join('').presence
    numbers ||= rand(0..9)
    numbers = "%02d" % numbers

    loop do
      code = "#{letters}/#{numbers}#{rand(10..90)}"
      break code if Project.where.not(id: id).where(code: code).none?
    end
  end

  private

  def strip_title
    self.title = title.gsub(/\s+/, ' ').strip
  end

  def assign_code
    return unless title.present?

    self.code = Project.generate_code(title, id)
  end
end
