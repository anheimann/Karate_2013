class HomeController < ApplicationController

  def index
    if logged_in? && current_user.role?(:admin)         # admin
      @upcoming_tournaments = Tournament.chronological.active.upcoming.all
      @past_tournaments = Tournament.chronological.active.past.all
      @active_students = Student.active.alphabetical.paginate(:page => params[:student_page]).per_page(10)
      @active_dojos = Dojo.active.alphabetical.paginate(:page => params[:dojo_page]).per_page(10)
    elsif logged_in? && current_user.role?(:member)     # member
      @upcoming_tournament = Tournament.active.upcoming.chronological.next(1).all
      @past_tournament = Tournament.active.past.chronological.next(1).all
      @student = current_user.student
      @dojo_history = @student.dojo_students.chronological.all
      @past_tournaments = @student.tournaments.past.chronological.paginate(:page => params[:page]).per_page(10)
    else                                                # public
      @upcoming_tournament = Tournament.active.upcoming.chronological.next(1).all
      @past_tournament = Tournament.active.past.chronological.next(1).all
    end
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def search
    @query = params[:query]
    @students = Student.search(@query)

    # source is http://stackoverflow.com/questions/3188157/how-to-set-up-jquery-ui-autocomplete-in-rails
    # if params[:term]
    #   @all_students = Student.find(:all,:conditions => ['first_name LIKE ? OR last_name LIKE ? ', "%#{params[:term]}%", "%#{params[:term]}%"])
    # else
    #   @all_students = Student.all
    # end
    # 
    # respond_to do |format|  
    #   format.html # index.html.erb  
    #   # Here is where you can specify how to handle the request for "/student.json"
    #   format.json { render :json => @all_students.to_json }
    # end
  end
end
