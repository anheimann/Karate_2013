class StudentsController < ApplicationController
  before_filter :check_login, :except => [:show]
  authorize_resource

  def index
    @active_students = Student.active.alphabetical.paginate(:page => params[:active_page]).per_page(10)
    @by_age_students = Student.by_age.alphabetical.paginate(:page => params[:age_page]).per_page(10)
    @by_rank_students = Student.by_rank.alphabetical.paginate(:page => params[:rank_page]).per_page(10)
    @inactive_students = Student.inactive.alphabetical.paginate(:page => params[:inactive_page]).per_page(10)
    @dan_students = Student.dans.alphabetical.paginate(:page => params[:dan_page]).per_page(10)
    @gup_students = Student.gups.alphabetical.paginate(:page => params[:gup_page]).per_page(10)
    @junior_students = Student.juniors.alphabetical.paginate(:page => params[:jr_page]).per_page(10)
    @senior_students = Student.seniors.alphabetical.paginate(:page => params[:sr_page]).per_page(10)
    @waivers_needed_students = Student.needs_waiver.alphabetical.paginate(:page => params[:waiver_page]).per_page(10)
  end

  def show
    @student = Student.find(params[:id])
    authorize! :show, @student
    @dojo_history = @student.dojo_students.chronological.all
    @past_tournaments = @student.tournaments.past.chronological.paginate(:page => params[:page]).per_page(10)
    @future_tournaments = @student.tournaments.upcoming.chronological.paginate(:page => params[:page]).per_page(10)

    # @registrations = @student.registrations.by_event_name.paginate(:page => params[:page]).per_page(10)
    @registrations = @student.registrations.by_date.paginate(:page => params[:page]).per_page(10)
    @registration = Registration.new
  end
  
  def new
    @student = Student.new
    user = @student.build_user
  end

  def edit
    @student = Student.find(params[:id])
    user = @student.build_user if @student.user.nil?
#   user = @student.user.build if @student.user.nil?      # also considered ... 
  end

  def create
    @student = Student.new(params[:student])
    if @student.save
      # if saved to database
      flash[:notice] = "Successfully created #{@student.proper_name}."
      redirect_to @student # go to show student page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @student = Student.find(params[:id])
    if @student.update_attributes(params[:student])
      flash[:notice] = "Successfully updated #{@student.proper_name}."
      redirect_to @student
    else
      render :action => 'edit'
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    flash[:notice] = "Successfully removed #{@student.proper_name} from karate tournament system"
    redirect_to students_url
  end
end