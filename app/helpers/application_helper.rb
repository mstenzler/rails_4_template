module ApplicationHelper

	#returns the full title on a per-page basis
	def full_title(page_title)
		base_title = CONFIG[:title] || "Ruby on Rails Template"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

  #returns the Display Name of the application
  def app_display_name
    CONFIG[:display_name] || "Ruby on Rails Template" 
  end

	#return class name for flash message based on type
  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success" # Green
      when :error
        "alert-danger" # Red
      when :alert
        "alert-warning" # Yellow
      when :notice
        "alert-info" # Blue
      else
        flash_type.to_s
    end
  end

end
