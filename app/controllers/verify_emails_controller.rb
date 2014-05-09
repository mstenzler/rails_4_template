class VerifyEmailsController < ApplicationController
	before_action :init_form,  only: [:new, :create]

  def new
    if params[:verify_email_form] && params[:verify_email_form][:verify_token]
    	create
    else
    	render 'new'
    end
  end

  def create
    if @verify_email_form.submit(params[:verify_email_form])
    	render 'verify_email_success'
    else
      render "new"
    end
  end
  
=begin
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
=end

  private

    def init_form
    	@user = current_user || User.find(params[:user_id])
    	@verify_email_form = VerifyEmailForm.new(@user)
    end
end