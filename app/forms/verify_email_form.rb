class VerifyEmailForm
  include ActiveModel::Model
 # extend ActiveModel::Naming
 # include ActiveModel::Conversion
 # include ActiveModel::Validations

  def persisted?
    false
  end

  attr_accessor :verify_token

#  validate :verify_original_password
  validates_presence_of :verify_token
  validate :verify_token_is_valid
#  validates_confirmation_of :new_password
#  validates_length_of :new_password, minimum: 6

  def initialize(user, token=nil)
    @user = user
    self.verify_token = token unless token.blank?
  end

  def submit(params)
    self.verify_token = params[:verify_token] unless params[:verify_token].blank?
    if valid?
    	@user.validate_email
    	true
    else
      false
    end
  end

  def verify_token_is_valid
#  	p "In verify_token_is_valid. verify_token = '#{self.verify_token}'."
#  	p "Hashed token = #{User.hash(self.verify_token)}"
#  	p "User.email_validation_token = '#{@user.email_validation_token}'"
  	unless (self.verify_token && (@user.email_validation_token == User.hash(self.verify_token)) )
#  		p "Adding is not valid error to errors"
  		errors.add :verify_token, "is not valid"
  	end
  end

end