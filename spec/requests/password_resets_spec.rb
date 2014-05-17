require 'spec_helper'

describe "PasswordResets" do

	subject { page }

  describe "emails user when requesting password reset" do
  	let(:user) { FactoryGirl.create(:user) }

  	before do
      visit signin_path
      click_link "password"
      fill_in "Email", :with => user.email
      click_button "Reset Password"
    end

    it { should have_content("Email sent") }
    specify { expect(last_email.to).to include(user.email) }
  end

	describe "does not email invalid user when requesting password reset" do
		before do
  	  visit signin_path
	    click_link "password"
	    fill_in "Email", :with => "madeupuser@example.com"
	    click_button "Reset Password"
	  end

	  it { should have_content("Email sent") }
	  specify { expect(last_email).to be_nil }
	end

end