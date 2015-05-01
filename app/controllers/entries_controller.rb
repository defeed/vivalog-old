class EntriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def new
    @entry = current_user.entries.new
  end

  def create
    @entry = current_user.entries.new(entry_params)
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

  private

  def entry_params
    params.require(:entry).permit(
      :project_id, :user_id, :work_type, :workers, :coefficient, :worked_on
    )
  end
end
