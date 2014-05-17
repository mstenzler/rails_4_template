include ApplicationHelper
#def full_title(page_title)
#  base_title = "Ruby on Rails Tutorial Sample App"
#  if page_title.empty?
#    base_title
#  else
#    "#{base_title} | #{page_title}"
#  end
#end

DEBUG_LEVEL = 0
UTC_TIME_ZONE_VALUE = "UTC"

def debug(msg, level=0)
  p "DEBUG: #{msg}" if DEBUG_LEVEL > level
end

def select_date(date, options={})
  raise ArgumentError, 'from is required option' if options[:from].blank?
  field = options[:from].to_s
  select date.year.to_s,               from: "#{field}_1i"
  select Date::MONTHNAMES[date.month], from: "#{field}_2i"
  select date.day.to_s,                from: "#{field}_3i"  
end


def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.hash(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end