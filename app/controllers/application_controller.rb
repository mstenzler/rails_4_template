class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  around_filter :user_time_zone, if: :current_user
  include SessionsHelper

#  p "CONFIG = '#{CONFIG}'"
#  p "user_form_options = '#{CONFIG[:user_form_options]}'"

  #For each of the user_form_options define require_#{option_name} and
  #enable_#{option_name} methods and make each one a helper method as well
  CONFIG[:user_form_options].each do |option_name|
  	enable_name = "enable_#{option_name}".to_sym
  	require_name = "require_#{option_name}".to_sym
  	use_name = "use_#{option_name}".to_sym
  	define_method enable_name do
  		CONFIG[enable_name]
  	end
  	helper_method enable_name
  	define_method require_name do
  		CONFIG[require_name]
  	end
  	helper_method require_name
  	define_method use_name do |user_object|
  		user_object.new_record? ? CONFIG[require_name] : CONFIG[enable_name]
  	end
  	helper_method use_name
  end

  def signed_in_user
  	unless signed_in?
  		store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  private

    #enables each individual user to use a specific time zone if selected
    def user_time_zone(&block)
      Time.use_zone(current_user.time_zone, &block) if !current_user.time_zone.blank?
    end

end
