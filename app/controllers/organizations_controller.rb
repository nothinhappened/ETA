class OrganizationsController < ApplicationController
  def new
    @organization = Organization.new
    @organization.users.build
  end

  def create
    @organization = Organization.new(organization_params)
    @organization.users.first.user_type=2
    if @organization.save
      Project.create_default_project(@organization.id)
      @user = @organization.users.first
      #The organization will only have one user, so we can select the first.
      sign_in @user
      flash[:success] = 'Excellent, welcome to ' + @organization.organization_name.to_s + '!'
      redirect_back_or time_entries_url
    else
      render 'new'
    end
  end

  private
  def organization_params
    params.require(:organization).permit(:id, :organization_name, :users_attributes => [:first_name, :last_name, :password, :email, :password_confirmation])
  end
end