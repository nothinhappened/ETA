class UnlockedTimesController < ApplicationController  
  before_action :signed_in_user
  before_action :redirect_unless_administrator
  before_action :set_unlocked_time, only: [:update, :destroy]

  # GET /unlocked_times
  # GET /unlocked_times.json
  def index
    @unlocked_times = UnlockedTime.by_organization(current_user.organization_id)    
  end

  # GET /unlocked_times/new
  def new
    @unlocked_time = UnlockedTime.new
    @unlocked_time.organization_id = current_user.organization_id
  end
  

  # POST /unlocked_times
  # POST /unlocked_times.json
  def create    
    @unlocked_time = UnlockedTime.new(unlocked_time_params)
    @unlocked_time.organization_id = current_user.organization_id

    respond_to do |format|
      if @unlocked_time.save
        flash[:success] = 'Unlocked time was successfully created.'
        format.html { redirect_to unlocked_times_url }
        format.json { render :show, status: :created, location: @unlocked_time }
      else
        format.html { render :new }
        format.json { render json: @unlocked_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unlocked_times/1
  # PATCH/PUT /unlocked_times/1.json
  def update
    # redirect_if_not_organization
    respond_to do |format|      
      if @unlocked_time.update(unlocked_time_params)
        flash[:success] = 'Unlocked time was successfully updated.'
        
        format.html { redirect_to unlocked_times_url}
        format.json { render :show, status: :ok, location: @unlocked_time }
      else
        # TODO: I am having trouble trying to get the error messages to be shown to the user
        # after the redirect_to index page, so we have this little hack here in the to get it workin..
        flash[:error] = 'Unlocked time was not updated.'
        unless  @unlocked_time.errors.messages[:end_time].nil?
          flash[:error] += ' End time ' + @unlocked_time.errors.messages[:end_time].first.to_s  + '.'      
        end

        format.html { redirect_to unlocked_times_url }
        format.json { render json: @unlocked_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unlocked_times/1
  # DELETE /unlocked_times/1.json
  def destroy
    # redirect_if_not_organization
    @unlocked_time.destroy
    respond_to do |format|
      flash[:success] = 'Unlocked time was successfully destroyed.'
      format.html { redirect_to unlocked_times_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unlocked_time
      @unlocked_time = UnlockedTime.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unlocked_time_params
      params.require(:unlocked_time).permit(:start_time, :end_time)
    end
end
