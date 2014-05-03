module ConfigSanitizer
	class ConfigError < StandardError
  end

	def check_config(config)
		#p "min_age = #{CONFIG[:min_age]}, enable_birthdate = #{CONFIG[:enable_birthdate?
		#If we have min_age or max_age set, then we must also set enable_birthdate? to true
		if ( (config[:min_age] || config[:max_age]) && (!config[:enable_birthdate?]) )
			raise ConfigError, "CONFIG[:enable_birthdate] must be true to use min_age or max_age"
		end

		['name?', 'username?', 'gender?', 'birthdate?'].each do |attribute|
			check_require_enabled(config, attribute)
		end

		true
	end

	private
 
  	def check_require_enabled(config, attribute)
#  		p "In check_require_enabled, config = '#{config}'"
  		require_sym = "require_#{attribute}".to_sym
  		enable_sym = "enable_#{attribute}".to_sym
  		p "Comparing '#{require_sym}' = '#{config[require_sym]}', '#{enable_sym}' = '#{config[enable_sym]}'"

  		if (config[require_sym] && !config[enable_sym])
  			raise ConfigError, "CONFIG[#{enable_sym.to_s}] must be true if CONFIG[#{require_sym.to_s}] is true"
  		end
  	end


end