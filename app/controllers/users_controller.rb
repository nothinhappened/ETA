class UsersController < ApplicationController
  before_action :signed_in_user   ,only: [:index,:update,:edit]
  before_action :correct_user     ,only: [:update,:edit]
  before_action :set_user         ,except: [:index, :index_archived, :create, :new]
  before_action :redirect_unless_administrator	,except: [:show, :edit, :update]
  before_filter :check_for_cancel ,only: [:update]

  def index
    @users = User.where(:organization_id => current_user.organization_id, :archived => false).paginate(page: params[:page])
  end

  def index_archived
    @users = User.where(:organization_id => current_user.organization_id, :archived => true).paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    @user.organization = current_user.organization

    if @user.save
      redirect_to users_url
    else
      flash[:notice] = 'User not created'
      render 'new'
    end
  end

  def new
    @user = User.new
  end

  def admin_edit
    flash[:warning] = 'This user is archived.' if @user.archived?
  end

  def admin_update
    params[:user].delete(:password) if params[:user][:password].blank?
    if @user.update_user(user_params)
      flash[:success] = 'Update successful!'
      redirect_to admin_edit_user_url
    else
      flash[:error] = 'Unable to update user'
      render 'admin_edit'
    end
  end

  def edit
  end

  def show
    unless current_user?(@user) or is_admin?(@current_user)
      if @current_user.nil?
        redirect_to home_page_url
      else
        redirect_to current_user
      end
    end
  end

  def update
    if @user.update_attributes(regular_edit_params)
      # success
      flash[:success] = 'Update successful!'
      redirect_to @user
    else
      flash.now[:error] = 'Sorry, something went wrong! Profile not updated.'
      render 'edit'
    end
  end

  def admin_show
  end

  def archive
    if @user.id == current_user.id
      flash[:error] = "You can't delete yourself."
    elsif @user.archive
      flash[:success] = 'User has been deleted'
    else
      flash[:error] = 'Unable to delete user'
    end
    redirect_to users_path
  end

  def unarchive
    if @user.unarchive
      flash[:success] = 'User has been restored'
    else
      flash[:error] = 'Unable to restore user'
    end
    redirect_to index_archived_users_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
    redirect_if_wrong_organization(@user)
  end

  def redirect_if_wrong_organization(user)
    unless user.organization_id == current_user.organization_id
      flash[:error] = "You don't have permission to do that!"
      redirect_to user
    end
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:first_name,:last_name,:email,:user_type,:password, :password_confirmation)
  end

  def regular_edit_params
    params.require(:user).permit(:first_name,:last_name,:email,:password, :password_confirmation)
  end

  def check_for_cancel
    # this is so confusing...  
    if params[:Cancel]
      redirect_to @user
    end
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:notice] = "You don't have permission to do that."
      redirect_to root_url
    end
  end

end
