require "spec_helper"

FROM_EMAIL = "mailer@example.com"

describe UserMailer do

  describe 'email validation' do
#    let(:user) { mock_model User, name: 'Lucas', email: 'lucas@email.com' }
    let(:user) { FactoryGirl.create(:user, email_validation_token: "fooooobarrr") }
    let(:mail) { UserMailer.email_validation_token(user) }
 
     describe "send email validation token url" do
      specify { expect(mail.subject).to eq("Email Validation Code")  }
      specify { expect(mail.to).to eq([user.email]) }
      specify { expect(mail.from).to eq([FROM_EMAIL]) }
      specify { expect(mail.body.encoded).to match(verify_email_token_path(user.id, user.email_validation_token)) }
 #     specify { expect(last_email).to include(user.email) }
    end
  end

  describe "password_reset" do
    let(:user) { FactoryGirl.create(:user, :password_reset_token => "anything") }
    let(:mail) { UserMailer.password_reset(user) }

    describe "sends user password reset url" do
      specify { expect(mail.subject).to eq("Password Reset") }
      specify { expect(mail.to).to eq([user.email]) }
      specify { expect(mail.from).to eq([FROM_EMAIL]) }
    end


    describe "renders the body" do
      specify { expect(mail.body.encoded).to match(edit_password_reset_path(user.password_reset_token)) }
    end
  end
end