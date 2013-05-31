class DojoStudentsController < ApplicationController
  before_filter :check_login
  authorize_resource

  def new
    @dojo_student = DojoStudent.new
    # if coming from a particular dojo's detail, or show page, then:
    @dojo_student.dojo_id = params[:dojo_id] unless params[:dojo_id].nil?
    # if coming from a particular student's detail, or show page, then:
    @dojo_student.student_id = params[:student_id] unless params[:student_id].nil?
  end

  def edit
    @dojo_student = DojoStudent.find(params[:id])
  end

  def create
    @dojo_student = DojoStudent.new(params[:dojo_student])
    if @dojo_student.save
      # if saved to database
        flash[:notice] = "Successfully created #{@dojo_student.student.proper_name}."
        redirect_to @dojo_student.student # go to show student page
      else
        # return to the 'new' form
        render :action => 'new'
      end
    
  end

  def update
    @dojo_student = DojoStudent.find(params[:id])
    if @dojo_student.update_attributes(params[:dojo_student])
      flash[:notice] = "Successfully updated #{@dojo_student.student.proper_name}."
      redirect_to @dojo_student.student
    else
      render :action => 'edit'
    end
  end
end
