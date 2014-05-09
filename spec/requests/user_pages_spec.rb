require 'spec_helper'

NAME_LABEL = "Name"
USERNAME_LABEL = "Username"
EMAIL_LABEL = "Email"
PASSWORD_LABEL = "Password"
CONFIRM_PASSWORD_LABEL = "Password confirmation"
GENDER_LABEL = "Gender"
BIRTHDATE_LABEL = "Birthdate"
TIME_ZONE_LABEL = "Time zone"

BIRTHDATE = Time.now - 25.years

describe "User pages" do

  subject { page }

  describe "index" do
  	let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submition" do
      	before { click_button submit }

      	it { should have_title('Sign up') }
      	it { should have_content('error') }
      end

      describe "after submit with bad email" do
      	before do
          fill_in NAME_LABEL,         with: "Example User"
          fill_in EMAIL_LABEL,        with: "user@example"
          fill_in PASSWORD_LABEL,     with: "foobar"
          fill_in CONFIRM_PASSWORD_LABEL, with: "foobar"
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Email is invalid') }
      end

      describe "after submit with blank password" do
      	before do
          fill_in NAME_LABEL,         with: "Example User"
          fill_in EMAIL_LABEL,        with: "user@example.com"
          fill_in PASSWORD_LABEL,     with: ""
          fill_in CONFIRM_PASSWORD_LABEL, with: ""
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Password can\'t be blank') }
      end

      describe "after submit with blank name" do
      	before do
          fill_in NAME_LABEL,         with: ""
          fill_in EMAIL_LABEL,        with: "user@example.com"
          fill_in PASSWORD_LABEL,     with: "foobar"
          fill_in CONFIRM_PASSWORD_LABEL, with: "foobar"
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Name can\'t be blank') }
      end

      describe "after submit with blank email" do
      	before do
          fill_in NAME_LABEL,         with: "Example User"
          fill_in EMAIL_LABEL,        with: ""
          fill_in PASSWORD_LABEL,     with: "foobar"
          fill_in CONFIRM_PASSWORD_LABEL, with: "foobar"
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Email can\'t be blank') }
      end

    	describe "after submit with mismatched password confirmation" do
      	before do
          fill_in NAME_LABEL,         with: "Example User"
          fill_in EMAIL_LABEL,        with: "user@example.com"
          fill_in PASSWORD_LABEL,     with: "foo"
          fill_in CONFIRM_PASSWORD_LABEL, with: "foobar"
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Password confirmation doesn\'t match Password') }
      end

     	describe "after submit with password too short" do
      	before do
          fill_in NAME_LABEL,         with: "Example User"
          fill_in EMAIL_LABEL,        with: "user@example.com"
          fill_in PASSWORD_LABEL,     with: "foo"
          fill_in CONFIRM_PASSWORD_LABEL, with: "foo"
          click_button submit
        end

        it { should have_content('error') }
        it { should have_content('Password is too short ') }
      end
     
    end

    describe "with valid information" do
      before do
        fill_in NAME_LABEL,             with: "Example User"
        fill_in USERNAME_LABEL,          with: "example_user"
        fill_in EMAIL_LABEL,            with: "user@example.com"
        fill_in PASSWORD_LABEL,         with: "foobar"
        fill_in CONFIRM_PASSWORD_LABEL, with: "foobar"
        select 'Male',           from: "Gender"
        select BIRTHDATE.year, from: 'user_birthdate_1i'
        select 'January', from: 'user_birthdate_2i'
        select BIRTHDATE.day, from: 'user_birthdate_3i'
#        fill_in BIRTHDATE_LABEL,        with: Date.today - 25.years
        select "Eastern Time (US & Canada)", from: 'time-zone-select'
#        save_and_open_page
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        if CONFIG[:verify_email?]
 #         p "Showing Verify Email Page after create"
          it { should have_title('Verify Email Address') }
        else
#          p "Redirecting to @user after create"
          it { should have_link('Sign out') }
          it { should have_title(user.name) }
          it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        end
      end

    end
  end

  if CONFIG[:verify_email?]
    describe "verify email" do

      let(:submit) { "Verify" }
      let(:user) { FactoryGirl.create(:user) }
      let(:verify_email_label) { 'Verify token' }

      before do
        user.save!
        visit new_user_verify_email_path(user) 
      end

      describe "page" do
        it { should have_title('Verify Email Address') }
      end

      describe "with blank token" do
        before { click_button submit }

        it { should have_content('error') }
      end

      describe "with invalid token" do 
        before do
          fill_in verify_email_label,  with: 'foobar'
          click_button submit
        end

        it { should have_content('error') }
        it { should have_title('Verify Email Address') }
      end

      describe "with valid token" do 
        before do
          opts = user.reset_email_validation_token
          user.save!
#          p "New token = '#{opts[:token]}'"
          fill_in verify_email_label,  with: opts[:token]
          click_button submit
        end

#        it { save_and_open_page; should_not have_content('error') }
        it { should_not have_content('error') }
        it { should have_title('Email Validation Success') }
        specify { expect(user.reload.email_validated).to eq true }
      end
    end
  end #if CONFIG[:verify_email?]

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
    	sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in NAME_LABEL,             with: new_name
        fill_in EMAIL_LABEL,            with: new_email
        fill_in PASSWORD_LABEL,         with: user.password
        fill_in CONFIRM_PASSWORD_LABEL, with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end

  end  


  describe "When signed in" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user, no_capybara: true
    end

    describe "get new user" do
      before do
 ##     	sign_in user, no_capybara: true
      	get new_user_path
      end	 
      specify { expect(response).to redirect_to(root_path) }
    end

#    describe "post create user" do
#      before do
#     	sign_in user, no_capybara: true
#     	post :create, :user => {}
#    #  	post :create, FactoryGirl.attributes_for(:user)
#      end 
#      specify { expect(response).to redirect_to(root_path) }
#    end
  end
end  

