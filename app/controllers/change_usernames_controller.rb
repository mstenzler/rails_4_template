class ChangeUsernamesController < ApplicationController
  before_action :signed_in_user

 	def edit
	  @user = User.find_by_id!(params[:id])
	end

 	def update
	  @user = User.find_by_id!(params[:id])
	  if @user.update_attributes(user_params)
	    redirect_to edit_user_url(@user), :notice => "Username has been changed."
	  else
	    render :edit
	  end
	end

  private

    def user_params
      params.require(:user).permit(:username)
    end
end
