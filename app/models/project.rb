class Project < ActiveRecord::Base
  validates_presence_of :title
  validate :ensure_correct_dates

  has_many :entries, dependent: :destroy
  has_many :workers, -> { uniq }, source: :user, through: :entries
  has_many :payouts
  belongs_to :finalizer, class_name: 'User', foreign_key: 'finalized_by'

  scope :not_finalized, -> { where(finalized_at: nil) }
  scope :finalized, -> { where.not(finalized_at: nil) }

  before_save :strip_array_attrs, :strip_title, :assign_code, :calculate_sums

  def self.search(params = {})
    result = all
    start_on = params[:start_on]
    end_on = params[:end_on]
    worked_on = params[:worked_on]
    query = params[:query]

    result = result.where(
      'title ILIKE ? OR code ILIKE ?',
      "%#{query}%", "%#{query}%"
    ) if query

    result = result.where('start_on >= ?', start_on.to_date) if start_on
    result = result.where('end_on <= ?', end_on.to_date) if end_on
    result = result.where(
      'start_on <= ? AND (end_on >= ? OR end_on IS NULL)',
      worked_on.to_date, worked_on.to_date
    ) if worked_on
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
    reasons.push :no_sum_receive if sum_receive.blank?
    reasons.push :no_sum_polish if sum_polish.blank?
    reasons.push :workers_receive_not_eql unless begin
      daily_entries = entries.with_type(:receive).count / length.to_f
      daily_entries == avg_workers_for(:receive)
    end
    reasons.push :workers_polish_not_eql unless begin
      daily_entries = entries.with_type(:polish).count / length.to_f
      daily_entries == avg_workers_for(:polish)
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
      entries.each { |e| e.finalize(user) }
      update(finalized_at: Time.now, finalizer: user)
      true
    end
  end

  def unfinalize
    entries(&:unfinalize)
    payouts.destroy_all
    update(finalized_at: nil, finalized_by: nil)
  end

  def finalized?
    !!finalized_at
  end

  def length
    return 1 unless end_on
    (start_on..end_on).count
  end

  def calculate_sums
    self.sum_receive = nil
    self.sum_polish = nil
    return if volume.blank?
    calculate_sum_receive
    calculate_sum_polish
  end

  def calculate_sum_receive
    self.sum_receive = nil
    return if sum_sq_receive.blank?
    self.sum_receive = volume * sum_sq_receive
  end

  def calculate_sum_polish
    self.sum_polish = nil
    return if sum_sq_polish.blank?
    self.sum_polish = volume * sum_sq_polish
  end

  def ensure_correct_dates
    return true unless start_on && end_on
    return true unless end_on
    return true if end_on >= start_on

    errors.add(:start_on, 'must start on same day or before end')
    errors.add(:end_on, 'must end on same day or after start')
  end

  def generate_code
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

  def strip_array_attrs
    self.work_types.reject!(&:blank?)
    self.billing_types.reject!(&:blank?)
  end

  def strip_title
    self.title = title.gsub(/\s+/, ' ').strip
  end

  def assign_code
    return unless title.present?
    return unless title_changed?

    self.code = generate_code
  end
end
