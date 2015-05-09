class EntriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def new
    @entry = current_user.entries.new
  end

  def create
    if params[:entry][:user_id]
      @entry = Entry.new(entry_params_for_user)
    else
      @entry = current_user.entries.new(entry_params)
    end

    if @entry.save
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
