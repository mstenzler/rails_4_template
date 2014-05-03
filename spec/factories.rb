FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" } 
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :full_config, class:Hash do
  	min_age 18 
  	max_age 140
    enable_name? true
    require_name? true
    enable_username? true
    require_username? true
    enable_gender? true
    require_gender? true
    enable_birthdate? true
    require_birthdate? true

    initialize_with { attributes } 
  end

  factory :mid_config, class:Hash do
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