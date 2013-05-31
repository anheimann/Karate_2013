class TournamentsController < ApplicationController
  before_filter :check_login, :except => [:index, :show]
  authorize_resource

  def index
    @active_tournaments = Tournament.active.chronological.paginate(:page => params[:page]).per_page(10)
    @inactive_tournaments = Tournament.inactive.chronological.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @tournament = Tournament.find(params[:id])
    t_events = @tournament.events.alphabetical.paginate(:page => params[:page]).per_page(10)
    if t_events.empty?
      @tournament_events = t_events
    else
      @tournament_events = t_events.uniq
    end
    
    @tournament_sections = @tournament.sections.alphabetical.paginate(:page => params[:section_page]).per_page(10)
    @tournament_students = @tournament.students.alphabetical.paginate(:page => params[:page]).per_page(10)
    @tournament_registrations = @tournament.registrations.by_student.paginate(:page => params[:registration_page]).per_page(10)
    @tournament_unpaids = @tournament.registrations.unpaid.by_student.paginate(:page => params[:unpaid_page]).per_page(10)
  end
  
  def new
    @tournament = Tournament.new
  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def clone
    @original = Tournament.find(params[:id])
    @clone = Tournament.new
    @clone.name = @original.name + " clone"
    @clone.date = @original.date
    @clone.min_rank = @original.min_rank
    @clone.max_rank = @original.max_rank
    @clone.active = @original.active
    @clone.save!
    unless @original.sections.nil?
      @original.sections.each do |s|
        clone_section = Section.new
        clone_section.tournament_id = @clone.id
        clone_section.event_id = s.event_id
        clone_section.min_age = s.min_age
        clone_section.max_age = s.max_age
        clone_section.min_rank = s.min_rank
        clone_section.max_rank = s.max_rank
        clone_section.round_time = s.round_time
        clone_section.location = s.location
        clone_section.active = s.active
        clone_section.save!
      end
    end
    if ((@original.sections.nil? && clone.sections.nil?) || (@original.sections.size == @clone.sections.size))
      flash[:notice] = "Successfully cloned #{@original.name}"
      redirect_to @clone
    else
      flash[:notice] = "Attempt to clone #{@original.name} aborted"
    end
    # redirect_to tournaments_url
  end

  def create
    @tournament = Tournament.new(params[:tournament])
    if @tournament.save
      # if saved to database
      flash[:notice] = "Successfully created #{@tournament.name}"
      redirect_to @tournament # go to show tournament page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attributes(params[:tournament])
      flash[:notice] = "Successfully updated #{@tournament.name}"
      redirect_to @tournament
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tournament = Tournament.find(params[:id])
    status = @tournament.destroy
    if status
      flash[:notice] = "Successfully removed #{@tournament.name} from karate tournament system"
    else 
      flash[:notice] = "#{@tournament.name} is changed to inactive because there are students associated with this tournament."
    end
    redirect_to tournaments_path    # originally: redirect_to touranments_url
  end
  
end