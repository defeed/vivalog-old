class ProjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @project = Project.new
    @projects = Project.search(params)
  end

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project, notice: t('projects.created')
    else
      @projects = Project.search
      render :index
    end
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: t('projects.updated')
    else
      render :show
    end
  end

  def destroy
    if @project.destroy
      redirect_to projects_path,
                  notice: t('projects.deleted', title: @project.title)
    end
  end

  def finalize
    result = @project.finalize(current_user)

    if result == true
      flash[:notice] = t('projects.finalized')
    else
      reasons = result.map do |reason|
        I18n.t("not_finalized_reasons.#{reason}")
      end.to_sentence(
        two_words_connector: t(:two_words_connector),
        last_word_connector: t(:last_word_connector)
      )

      flash[:error] = t('projects.cannot_be_finalized', reasons: reasons)
    end
    redirect_to @project
  end

  def find_by_start_date
    render json: Project.not_finalized
                        .search(worked_on: params[:worked_on])
                        .select(:id, :code, :title)
  end

  private

  def project_params
    params
      .require(:project)
      .permit(
        :title,
        :start_on,
        :end_on,
        :volume,
        :sum_sq_receive,
        :sum_sq_polish,
        :hourly_rate,
        :daily_rate,
        :project_rate,
        :work_types => [],
        :billing_types => []
      )
  end
end
