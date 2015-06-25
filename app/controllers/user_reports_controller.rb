class UserReportsController < ApplicationController
  before_action :redirect_unless_administrator

  def index
    @users = User.where(:organization_id => current_user.organization_id, :archived => false).paginate(page: params[:page])

  end

  def edit
    @report = UserReport.new(user_id: params[:id], start_time: params[:start_date], end_time: params[:end_date])
    @report.run_report

  end


  def get_last_month
      redirect_to controller: "user_reports", action: "edit", start_date: params[:start_date].to_time - 1.month, id: params[:id], end_date: params[:start_date].to_time - 1.day
  end

  def get_next_month
    redirect_to controller: "user_reports", action: "edit", start_date: params[:start_date].to_time + 1.month, id: params[:id], end_date: params[:start_date].to_time + 2.month - 1.day
  end

end

