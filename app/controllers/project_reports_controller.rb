class ProjectReportsController < ApplicationController
  before_action :redirect_unless_administrator

  def index
    @projects = Project.by_organization(current_user.organization_id)
  end


  def edit
    @project = ProjectReport.new(id: params[:id], start_time: params[:start_date], end_time: params[:end_date])
    @project.run_report
    if @project.task_reports.blank?
      flash[:error] = 'No tasks have been added to the project'
      redirect_to project_reports_index_path
    end

  end


  def get_last_month
    redirect_to controller: "project_reports", action: "edit", start_date: params[:start_date].to_time - 1.month, id: params[:id], end_date: params[:start_date].to_time - 1.day
  end

  def get_next_month
    redirect_to controller: "project_reports", action: "edit", start_date: params[:start_date].to_time + 1.month, id: params[:id], end_date: params[:start_date].to_time + 2.month - 1.day
  end

end

