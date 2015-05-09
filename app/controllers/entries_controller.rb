class EntriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def new
    @entry = current_user.entries.new
  end

  def create
    if final_date = params[:entry][:final_date].presence
      first_day = params[:entry][:worked_on].to_date.next_day
      final_day = final_date.to_date
      period = (first_day..final_day)
    end

    if params[:entry][:user_id]
      @entry = Entry.new(entry_params_for_user)
    else
      @entry = current_user.entries.new(entry_params)
    end

    if @entry.save
      create_additional_entries(period, @entry.user_id)
      redirect_to new_entry_path
    else
      render :new
    end
  end

  def destroy
    if @entry.destroy
      redirect_to project_path(@entry.project)
    end
  end

  def finalize
    result = @entry.finalize(current_user)
    redirect_to @entry.project, notice: t('entries.finalized')
  end

  private

  def create_additional_entries(days, user_id)
    days.each do |day|
      params = entry_params.merge!(user_id: user_id, worked_on: day)
      Entry.create!(params)
    end
  end

  def entry_params
    params.require(:entry).permit(
      :project_id,
      :work_type,
      :billing_type,
      :workers,
      :coefficient,
      :worked_on,
      :final_date,
      :multiple_days,
      :hours,
      :hourly_rate,
      :daily_rate,
      :project_rate,
      :comment
    )
  end

  def entry_params_for_user
    params.require(:entry).permit!
  end
end
