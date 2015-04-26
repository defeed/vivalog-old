class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
    @entries = @project.entries
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    if @project.destroy
      redirect_to root_path
    end
  end

  private

  def project_params
    params
      .require(:project)
      .permit(
        :title,
        :date,
        :volume,
        :price_receive,
        :price_polish,
        :price_other
      )
  end

  def find_project
    @project = Project.find(params[:id])
  end
end
