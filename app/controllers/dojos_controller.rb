class DojosController < ApplicationController
  before_filter :check_login, :except => [:index, :show]
  authorize_resource

  def index
    @active_dojos = Dojo.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_dojos = Dojo.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @dojo = Dojo.find(params[:id])
    if (logged_in? && (current_user.role? :admin))                      # admin only
    # @current_members = @dojo.current_students.paginate(:page => params[:page]).per_page(10)  is incorrect! (want dojo_students not students)
      @current_memberships = @dojo.dojo_students.current.by_student.paginate(:page => params[:current_m_page]).per_page(10)
    elsif (logged_in? && (current_user.student.current_dojo == @dojo))  # member of this dojo only
      @current_memberships = @dojo.dojo_students.current.by_student.paginate(:page => params[:page]).per_page(10)
    else
      @current_memberships = Array.new
    end
  end
  
  def new
    @dojo = Dojo.new
  end

  def edit
    @dojo = Dojo.find(params[:id])
  end

  def create
    @dojo = Dojo.new(params[:dojo])
    if @dojo.save
      # if saved to database
      flash[:notice] = "Successfully created #{@dojo.name} dojo"
      redirect_to @dojo # go to show dojo page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @dojo = Dojo.find(params[:id])
    if @dojo.update_attributes(params[:dojo])
      flash[:notice] = "Successfully updated #{@dojo.name} dojo"
      redirect_to @dojo
    else
      render :action => 'edit'
    end
  end

  def destroy    
    @dojo = Dojo.find(params[:id])
    status = @dojo.destroy
    if status
      flash[:notice] = "Successfully removed #{@dojo.name} from karate tournament system"
    else 
      flash[:notice] = "#{@dojo.name} is changed to inactive because there are students associated with this dojo."
    end
    redirect_to dojos_url
  end
  
end
