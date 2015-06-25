class StaticPagesController < ApplicationController
  before_action :signed_in_user, only: [:help]  
  def home
  	#@timesheet = current_user.timesheets.build if signed_in?
  	if signed_in?
  		redirect_to time_entries_url
  	end
  end

  def contact
    @current_user = current_user
    #web.uvic.ca/~fmd/contact.html
    #redirect_to "www.google.com"
    redirect_to "http://web.uvic.ca/~fmd/contact.html"
  end
  
  def help
    @current_user = current_user    
  end

  def about
    @current_user = current_user
    redirect_to "http://web.uvic.ca/~fmd/about.html"    
  end

  def company_website
    redirect_to "http://web.uvic.ca/~fmd/"    
  end
end
