class ProjectsController < ApplicationController
  before_action :signed_in_user
  before_action :redirect_unless_administrator, except: [:show]
  before_action :set_project, only: [:edit,:update, :show]

  def new
    @project = Project.new
  end

  def show
  end

  def create
    @project = Project.new(project_params)
    @project.organization_id = current_user.organization_id
    if @project.save
      redirect_to :action=>'index'
    else
      flash[:error] = 'Unable to create new project'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path
      flash[:success] = 'Project has been updated'
    else
      render 'edit'
      flash[:error] = 'Project could not be updated'
    end
  end

  def index
    @projects = Project.by_organization(current_user.organization_id)
  end

  private
  def project_params
    params[:project].permit(:title, :description)
  end

  def set_project
    @project = Project.find(params[:id])
    redirect_if_wrong_org(@project,'You do not have permission to edit this project.','projects', 'index')
  end
end
