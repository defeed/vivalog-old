class ProjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @project = Project.new
    @projects = Project.search(params[:query])
  end

  def show
    @entries = @project.entries
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project, notice: 'Project created'
    else
      @projects = Project.search
      render :index
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project details updated'
    else
      render :show
    end
  end

  def destroy
    if @project.destroy
      redirect_to projects_path, notice: "Project #{@project.title} deleted"
    end
  end

  def finalize
    result = @project.finalize

    if result == true
      flash[:notice] = 'Project has been finalized'
    else
      reasons = result.map do |reason|
        I18n.t("not_finalized_reasons.#{reason}")
      end.to_sentence

      flash[:error] = "Project cannot be finalized because #{reasons}"
    end
    redirect_to @project
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
end
