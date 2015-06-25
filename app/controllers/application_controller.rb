class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :is_admin?,:current_user,:current_user?,:current_user=

      # Used when an object is trying to be accessed, redirects if the organization of the object doesn't match the organization of the current_user
      # @param [Object] obj : an object with an organization_id which needs to be checked against the current user
      # @param [String] message : A message to display if the verification fails, i.e. "You do not have permission to edit."
      # @param [String] redirect_controller : The controller to redirect to if the verification fails, i.e. "projects"
      # @param [String] redirect_action : The action to redirect to if the verification fails, i.e. "index"
      def redirect_if_wrong_org(obj,message,redirect_controller, redirect_action)
        unless obj.organization_id == current_user.organization_id
          flash[:error] = message
          redirect_to controller: redirect_controller, action: redirect_action
        end
      end


  # helper methods for signing-in/out of the system.
  # 1. This will generate unique hashes for the session.
  # 2. Stores the hash in a cookie.
  # 3. Updates the user hash entry in the db.
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.current_user = user
  end

  # 1. Store a dead hash in the db in order to invalidate the current session hash.
  # 2. Delete from the cookie store.
  def sign_out
    current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  # Check to see if a user is signed in already ( i.e. active session)
  def signed_in?
    !current_user.nil?
  end
  # Check to see if a user is signed in.
  def signed_in_user
    unless signed_in?
      flash[:notice] = 'Please sign in.'
      store_location
      redirect_to signin_url
    end
  end

  # Interface for checking if the user has certain privileges
  # TODO: May need to rework/redesing the implementation of this
  # TODO: implement is_non_user, is_normal_user
  # Idea: Use the "has" pattern
  def is_admin?(user)
    (not user.nil?) and user.user_type == 2
  end

  # Accesor methods of getting/setting the user for the current session
  def current_user?(user)
    (not user.nil?) and (not current_user.nil?) and user == current_user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  # Methods user for "smart" redirection
  # for the cases where the user tries to navigate to a certain page
  # but must first login first. This will save the 'target' page they
  # were trying to go to, and once they authenticate then the system
  # will redirect them to the target page.
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def redirect_unless_administrator
    unless is_admin?(current_user)
      flash[:error] = 'You must be an administrator to do that!'
      if current_user.nil?
        redirect_to home_page_url
      else
        redirect_to @current_user
      end
    end
  end
end
