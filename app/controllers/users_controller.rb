class UsersController < ApplicationController
  before_filter :check_login, :except => [:new, :create]

  def index
    @users = User.alphabetical.paginate(:page => params[:page]).per_page(8)
  end

  # def show
  #   @user = User.find(params[:id])
  # end

  def create
    @user = User.new(params[:user])
    
    if @user.save!
    # redirect_to(@user, :notice => 'User was successfully created.')
      session[:user_id] = @user.id 
      redirect_to home_path   
    else
      render :action => "new"
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
#      redirect_to(@user, :notice => 'User was successfully updated.')     # if there is a view/user/show.html.erb
      redirect_to home_path
    else
      render :action => "edit"
    end
  end

  # def destroy
  #   @user = User.find(params[:id])
  #   @user.destroy
  #   flash[:notice] = "Successfully removed #{@user.email} from the system."
  #   redirect_to users_url
  # end

end
