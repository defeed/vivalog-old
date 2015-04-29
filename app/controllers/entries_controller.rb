class EntriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(entry_params)
    if @entry.save
      redirect_to project_path(@entry.project)
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
      :project_id, :work_type, :workers, :coefficient, :worked_on
    )
  end
end
