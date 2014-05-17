class ChangeEmailForm
  include ActiveModel::Model

  def persisted?
    false
  end

  attr_accessor :email

  validates :email, presence: true, format: { with: User::VALID_EMAIL_REGEX }

  validate :check_email

#  validate :verify_token_is_valid
#  validates_confirmation_of :new_password
#  validates_length_of :new_password, minimum: 6

  def initialize(user)
    @user = user
  end

  def submit(params)
    self.email = params[:email]
    self.email.downcase! if email
    if valid?
    	@user.reset_email(email)
    	true
    else
      false
    end
  end

  def check_email
    if @user.email == self.email
      errors.add :email, "already the current email"
    end
    if User.find_by_email(self.email)
      errors.add :email, "Already taken"
    end
  end

end