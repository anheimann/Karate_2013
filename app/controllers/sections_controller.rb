class SectionsController < ApplicationController
  before_filter :check_login, :except => [:index, :show]
  authorize_resource

  def index
    @active_sections = Section.active.alphabetical.paginate(:page => params[:active_page]).per_page(10) 
    @inactive_sections = Section.inactive.alphabetical.paginate(:page => params[:inactive_page]).per_page(10) 
    @upcoming_tournaments = Tournament.active.upcoming.chronological.paginate(:page => params[:page]).per_page(10) 
    @tournament = Tournament.new
  end

  def show
    @section = Section.find(params[:id])
    @section_students = @section.students.alphabetical.paginate(:page => params[:page]).per_page(10)
    @section_registrations = Registration.for_section(@section).by_final_standing.paginate(:page => params[:page]).per_page(10)
    @registration = Registration.new
  end
  
  def new
    @section = Section.new
    # if coming from a particular tournament's detail, or show page, then:
    @section.tournament_id = params[:tournament_id] unless params[:tournament_id].nil?
  end

  def edit
    @section = Section.find(params[:id])
  end

  def create
    @section = Section.new(params[:section])
    if @section.save
      # if saved to database
      flash[:notice] = "Successfully created section."
      redirect_to @section # go to show section page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @section = Section.find(params[:id])
    if @section.update_attributes(params[:section])
      flash[:notice] = "Successfully updated section."
      redirect_to @section
    else
      render :action => 'edit'
    end
  end

  def destroy
    @section = Section.find(params[:id])
    @section.destroy
    flash[:notice] = "Successfully removed #{@section.name} from karate tournament system"
    redirect_to sections_url
  end
end