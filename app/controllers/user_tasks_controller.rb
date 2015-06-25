require 'json'
class UserTasksController < ApplicationController
  before_action :redirect_unless_administrator
  before_action :set_user, only: [:edit,:update]
  before_action :set_user_task, only: [:show]

  def show
  end

  def index
    @user_tasks = Array.new
    @user = User.find_by_organization_id(current_user.organization_id)
    redirect_to edit_user_task_url(@user)
  end

  def edit
    @user_tasks = Array.new
  end

  def update
    @user_tasks = Array.new
    UserTask.by_user(@user.id).delete_all
    tasks_int_array = JSON.parse(params[:selected_tasks_json]).map(&:to_i)
    tasks_objects =Task.by_organization(current_user.organization_id).to_a.select { |task| (tasks_int_array.include? task.id) }

    tasks_objects.each do |task|
      @user_tasks << UserTask.create(
          {
              task_id: task.id,
              user_id: @user.id
          })
    end

    flash[:success] = 'Your changes have been saved.'
    render 'edit'
  end

  private
  def get_params
    params.require(:user_task).require(:user_id,:task_id)
  end

  def set_user
    @user = User.find(params[:id])
    redirect_if_wrong_org(@user,'You do not have permission to update this user.', 'user_tasks', 'index')
  end

  def set_user_task
    @user_task = UserTask.find(params[:id])
    redirect_if_wrong_org(@user_task.user,"You do not have permission to view this user's information.", 'user_tasks', 'index')
  end
end
