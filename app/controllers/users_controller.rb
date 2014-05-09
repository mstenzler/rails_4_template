class UsersController < ApplicationController
	before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
	before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  before_action :is_signed_in,   only: [:new, :create]

  def index
  	@users = User.paginate(page: params[:page])
  end

	def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)  
#    p "IN CREATE: @user.gender = '#{@user.gender}', @user.birthdate = '#{@user.birthdate}'"
    @user.set_create_ip_addresses(request.remote_ip)
    if @user.save
    	sign_in @user
      if CONFIG[:verify_email?]
        redirect_to new_user_verify_email_path(@user)
#        render 'show_verify_email'
      else
    	  flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      end
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
    	flash[:success] = "Profile updated"
      redirect_to @user
      # Handle a successful update.
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    if (current_user == user) && (current_user.admin?)
    	flash[:error] = "Can not delete own admin acount!"
    else
    	user.destroy
      flash[:success] = "User deleted."
    end
    redirect_to users_url
  end

  def verify_email
    @user = User.find(params[:id])
    verify_token = params[:verify_token]
    if verify_token
      if @user.email_validation_token == User.hash(verify_token)
        @user.validate_email
        render 'verify_email_success'
      else
        flash[:error] = "Not a valid email validation token for this user"
        render 'show_verify_email'
      end
    else
      render 'show_verify_email'
    end
  end

  def username_taken?(uname)
    User.username_taken?
  end

  private

    def user_params
      params.require(:user).permit(:name, :username, :email, :password,
                                   :password_confirmation, :gender, :birthdate, :time_zone)
    end

    # Before filters

    def signed_in_user
    	unless signed_in?
    		store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def is_signed_in
    	redirect_to(root_url) if signed_in?
    end
end
