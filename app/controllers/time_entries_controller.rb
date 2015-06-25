class TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: [:show, :edit, :update,:destroy]
  before_action :signed_in_user, only: [:index,:update,:edit,:destroy]

  # GET /time_entires/get_time_entries
  def get_time_entries
    respond_to do |format|
      format.json{
        render json: params
      }
    end
  end

  def update_table
    respond_to do |format|
      format.json {
        render json: params
      }
    end
  end

  def update_time_entry_description
    respond_to do |format|
      format.json{
      }
    end
  end

  # GET /time_entries  
  def index
    @current_user = current_user
    @start_date = params[:start_date] ? params[:start_date].to_date : Time.now.monday
  end

  # GET /time_entries/get_target_week
  def get_target_week
    if params[:target_date] &&  params[:target_date] =~ /\A\d\d\d\d-\d\d-\d\d\z/
      redirect_to controller: "time_entries", action: "index", 
                  start_date: params[:target_date].to_date.beginning_of_week()
    else
      flash[:error] = "Sorry unable to redirect to that date."
      redirect_to controller: "time_entries", action: "index"
    end    
  end

  # GET /time_entries/get_last_week
  def get_last_week
    if params[:start_date] && params[:next_date_direction]      
      if params[:next_date_direction].to_i == 0
        start_date = params[:start_date].to_date - 7.days
      elsif params[:next_date_direction].to_i == 1
        start_date = params[:start_date].to_date + 7.days
      else
        start_date = Time.now.Monday
      end
      redirect_to controller: 'time_entries', action: 'index', start_date: start_date
    else
      redirect_to controller: 'time_entries', action: 'index'
    end
  end

  # POST /time_entries/update_timesheet
  def update_timesheet
    respond_to do |format|
      format.html {
        # TODO: This will fail if a new task is added to the use right-before they submit.
        if TimeEntry.save_all_time_entries(params,current_user)
          flash[:success] = 'Successfully updated time entries!'
        else
          flash[:notice] = 'No entries were updated.'
        end
        redirect_to controller: 'time_entries', action: 'index', start_date: params[:start_date]
      }

      format.json {
        flash[:success] = 'Changed were saved succesfully '
        render :index, status: :ok
      }
      format.js {}
    end
  end

  # GET /time_entries/1
  # GET /time_entries/1.json
  def show
  end

  # GET /time_entries/new
  def new
    @time_entry = TimeEntry.new
  end

  # GET /time_entries/1/edit
  def edit
  end

  # POST /time_entries
  # POST /time_entries.json
  def create
    @time_entry = TimeEntry.new(time_entry_params)

    respond_to do |format|
      if @time_entry.save
        format.html { redirect_to @time_entry, notice: 'Time entry was successfully created.' }
        format.json { render :show, status: :created, location: @time_entry }
      else
        format.html { render :new }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_entries/1
  # PATCH/PUT /time_entries/1.json
  def update
    respond_to do |format|
      if @time_entry.update(time_entry_params)
        format.html { redirect_to @time_entry, notice: 'Time entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_entry }
      else
        format.html { render :edit }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_entries/1
  # DELETE /time_entries/1.json
  def destroy
    @time_entry.destroy
    respond_to do |format|
      format.html { redirect_to time_entries_url, notice: 'Time entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_time_entry
    @time_entry = TimeEntry.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def time_entry_params
    params.require(:time_entry).permit(:start_time, :duration, :organization_id, :task_id, :user_id)
  end
end