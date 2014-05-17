FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" } 
    sequence(:email) { |n| "person_#{n}@example.com" }
    sequence(:username) { |n| "username_#{n}"}
    password "foobar"
    password_confirmation "foobar"
    gender "Male"
    self.birthdate { Date.today - 25.years }
    time_zone "Eastern Time (US & Canada)"
    admin false

    factory :admin do
      admin true
    end
  end

  factory :min_user, class: User do
    sequence(:name)  { |n| "Person #{n}" } 
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :min_admin do
      admin true
    end
  end

  factory :full_config, class:Hash do
  	min_age 18 
  	max_age 140
  	user_form_options ['name?', 'username?', 'gender?', 'birthdate?', 'time_zone?']
    enable_name? true
    require_name? true
    enable_username? true
    require_username? true
    enable_gender? true
    require_gender? true
    enable_birthdate? true
    require_birthdate? true
    enable_time_zone? true
    require_time_zone? true

    initialize_with { attributes } 
  end

  factory :mid_config, class:Hash do
  	user_form_options ['name?', 'username?', 'gender?', 'birthdate?', 'time_zone?']
    enable_name? true
    require_name? false
    enable_username? true
    require_username? false
    enable_gender? true
    require_gender? false
    enable_birthdate? true
    require_birthdate? false

    initialize_with { attributes } 
  end

  factory :min_config, class:Hash do
  	user_form_options ['name?', 'username?', 'gender?', 'birthdate?', 'time_zone?']
    enable_name? false
    require_name? false
    enable_username? false
    require_username? false
    enable_gender? false
    require_gender? false
    enable_birthdate? false
    require_birthdate? false

    initialize_with { attributes } 
  end
end