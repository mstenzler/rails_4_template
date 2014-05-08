require 'spec_helper'

def reload_user
  Object.send(:remove_const, :User)
  load(File.expand_path("app/models/user.rb", Rails.root))
end

def create_user(opts = {})
  args = { name: "Example User", username: "miketheuser4", email: "user@example.com",
           password: "foobar", password_confirmation: "foobar", 
           gender: User::MALE_VALUE, birthdate: Time.now-25.years }
  args.merge!(opts)
  @user = User.new(args)
  debug "In create_user. user = #{@user.inspect}"
end

#CONFIG = FactoryGirl.build(:full_config)

describe User do

  p "*******DEBUG_LEVEL = '#{DEBUG_LEVEL}'"
  #p "CONFIG = '#{CONFIG}'"
#  CONFIG[:require_username?] = false
#  CONFIG[:enable_username?] = true
  CONFIG = FactoryGirl.build(:full_config)
  debug "CONFIG = '#{CONFIG}'", 2
  reload_user
#  Object.send(:remove_const, :User)
#  load(File.expand_path("app/models/user.rb", Rails.root))


  before do
 #   Object.send(:remove_const, :User)
#    CONFIG = FactoryGirl.build(:config, enable_username_1?: false, require_username?: false, require_gender?: false, require_birthday?: false)
 #CONFIG[:require_username?] = false
 # CONFIG[:enable_username?] = false
 #   load(File.expand_path("app/models/user.rb", Rails.root))
   # @user = User.new(name: "Example User", email: "user@example.com",
    #               password: "foobar", password_confirmation: "foobar") 
    create_user
  
  end

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token)}
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }

  if CONFIG[:enable_name?]
    it { should respond_to(:name) }
  end

  if CONFIG[:enable_username?]
    it { should respond_to(:username) }
  end

  if CONFIG[:enable_gender?]
    it { should respond_to(:gender) }
  end

  if CONFIG[:enable_birthdate?]
    it { should respond_to(:birthdate) }
  end

  it { should be_valid }
  it { should_not be_admin}

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when email is not present" do
    before { @user.email = " "}
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

	describe "when password is not present" do
	  before do
	    @user = User.new(name: "Example User", email: "user@example.com",
	                     password: " ", password_confirmation: " ")
	  end
	  it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
	  before { @user.password_confirmation = "mismatch" }
	  it { should_not be_valid }
	end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  if CONFIG[:require_name?]
    describe "when name is not present" do
      before { @user.name = " " }
      it { should_not be_valid }
    end

    describe "when name is too long" do
      before { @user.name = "a" * (User::NAME_MAX_LENGTH + 1) }
      it { should_not be_valid }
    end  
    describe "when name is too short" do
      before { @user.name = "a" * (User::NAME_MIN_LENGTH - 1) }
      it { should_not be_valid }
    end  
  end

  if CONFIG[:require_username?]
    describe "when username is not present" do
      before { @user.username = " " }
      it { should_not be_valid }
    end

    describe "when username is too long" do
      before do
       @user.username = "a" * (User::USERNAME_MAX_LENGTH + 1) 
       p "username length = #{@user.username.length}, USERNAME_MAX_LENGTH +1 = #{User::USERNAME_MAX_LENGTH + 1}"
     end
      it { should_not be_valid }
    end

    describe "when username starts with a number" do
      before { @user.username = "3forty" }
      it { should_not be_valid }
    end
  end #if require_username?

  if CONFIG[:require_gender?]
    describe "when gender is not present" do
      before { @user.gender = " " }
      it { should_not be_valid }
    end

    describe "when gender is not a valid gender" do
      before { @user.gender = "foobar" }
      it { should_not be_valid }
    end
  end

  if CONFIG[:require_birthdate?]
    describe "when birthdate is not present" do
      before { @user.birthdate = " "}
      it { should_not be_valid }
    end

    if CONFIG[:min_age]
      describe "when age is less than min_age" do
        before { @user.birthdate = (CONFIG[:min_age].to_i-1).years.ago }
        it { should_not be_valid }
      end
    end

    if CONFIG[:max_age]
      describe "when age is greater than max_age" do
        before { @user.birthdate = (CONFIG[:max_age].to_i+1).years.ago }
        it { should_not be_valid }
      end
    end
  end



  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "username_taken? function" do
    before do
      @user.username = 'foobartest1'
      @user.save
    end

    it "should be true" do
      expect(User.username_taken?('foobartest1')).to eq true 
    end
    it "should be false" do
      expect(User.username_taken?('foobartest2')).to eq false
    end
  end

end
