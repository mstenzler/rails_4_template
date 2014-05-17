class ChangeEmailsController < ApplicationController
  before_action :signed_in_user
	before_action :init_form,  only: [:edit, :update]

  SUCCESS_MESSAGE = "Your Email has been changed!"

 	def edit
	end

 	def update
	  if @user.update_attributes(user_params)
#    if @change_email_form.submit(params[:change_email_form])
      @user.init_unvalidated_email
      @user.save!
      if CONFIG[:verify_email?]
        redirect_to new_user_verify_email_path(@user), :notice => SUCCESS_MESSAGE
      else
#    	  flash[:success] = "Your Email has been changed!"
        redirect_to edit_user_url(@user), :notice => SUCCESS_MESSAGE
      end
#	    redirect_to root_url, :notice => "Email has been reset."
	  else
	    render :edit
	  end
	end

  private

    def user_params
      params.require(:user).permit(:email)
    end

    def init_form
    	@user = current_user
    end
end
