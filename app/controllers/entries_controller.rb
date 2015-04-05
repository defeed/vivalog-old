class EntriesController < ApplicationController
  before_action :find_entry, only: [:show, :edit, :update, :destroy]
  before_action :find_project, only: [:index, :new, :create]

  def index
    @entries = @project.entries
  end

  def new
    @entry = @project.entries.new
  end

  def create
    @entry = @project.entries.new(entry_params)
    if @entry.save
      redirect_to project_entries_path(@entry.project)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @entry.update(entry_params)
      redirect_to project_entries_path(@entry.project)
    else
      render :edit
    end
  end

  def destroy
    if @entry.destroy
      redirect_to project_entries_path(@entry.project)
    end
  end

  private

  def entry_params
    params.require(:entry).permit(
      :work_type, :workers, :coefficient, :worked_on
    )
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def find_entry
    @entry = Entry.find(params[:id])
  end
end
