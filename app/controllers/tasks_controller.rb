class TasksController < ApplicationController
  before_action :signed_in_user
  before_action :redirect_unless_administrator, except: [:show]
  before_action :set_task ,except: [:index, :new, :create, :index_archived]

  def new
    @task = Task.new
  end

  def index
    @tasks = Task.where(:organization_id => current_user.organization_id, :archived => false)
  end

  def index_archived
    @tasks = Task.where(:organization_id => current_user.organization_id, :archived => true)
  end

  def archive
    if @task.archive
      flash[:success] = 'Task has been archived'
      redirect_to tasks_path
    else
      flash[:error] = 'Task could not be updated'
      render :index
    end
  end

  def unarchive
    if @task.unarchive
      flash[:success] = 'Task has been unarchived'
      redirect_to index_archived_tasks_path
    else
      flash[:error] = 'Task could not be updated'
      render :index_archived
    end
  end

  def create
    @task = Task.new(task_params)
    @task.organization_id=current_user.organization_id
    @task.archived=false
    if @task.save
      save_all_user_tasks(@task.id)
      redirect_to :action=>'index'
    else
      flash[:error] = 'Unable to create new task'
      render 'new'
    end
  end

  def edit
  end

  def show
  end

  def update
    if @task.update(task_params)
      save_all_user_tasks(@task.id)
      redirect_to tasks_path
    else
      render 'edit'
    end
  end

  private
  def task_params
    params.permit(:name, :description, :project_id, :task_time)
  end

  def set_task
    @task = Task.find(params[:id])
    redirect_if_wrong_org(@task,'You do not have permission to edit this task.','tasks','index')
  end

  # @param [Task] task_id task_id of the task to be associated with users
  def save_all_user_tasks(task_id)
    UserTask.by_task(task_id).delete_all
    @user_tasks=Array.new
    users_int_array = JSON.parse(params[:selected_users_json]).map(&:to_i)
    users =User.by_organization(current_user.organization_id).to_a.select { |user| users_int_array.include? user.id }
    users.each do |user|
      @user_tasks << UserTask.create({
        task_id: task_id,
        user_id: user.id
      })
    end
  end
end