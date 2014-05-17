class User < ActiveRecord::Base
	before_save { email.downcase! }
	before_create :create_remember_token
  before_save :init_new_user

  attr_accessor :verify_token 

  PASSWORD_RESET_TTL_HOURS = CONFIG[:password_reset_ttl_hours] || 2

  NAME_MAX_LENGTH = 32
  NAME_MIN_LENGTH = 2
  USERNAME_MAX_LENGTH = 24
  USERNAME_MIN_LENGTH = 2
  EMAIL_MAX_LENGTH = 50
  EMAIL_MIN_LENGTH = 4
	
#	validates :name, presence: true, length: { maximum: 50 }
#	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_NAME_REGEX = /\A[a-z\d\-\_\s]+\z/i
  VALID_USERNAME_REGEX = /\A[a-z]{1}[a-z\d\-\_]+\z/i

  VALID_GENDERS = ["Male", "Female", "Transgender", "Other"]
  MALE_VALUE = VALID_GENDERS[0]
  FEMALE_VALUE = VALID_GENDERS[1]
  TRANSGENDER_VALUE = VALID_GENDERS[2]
  OTHER_GENDER_VALUE = VALID_GENDERS[3] 

  START_YEAR = 1900
  VALID_DATES = DateTime.new(START_YEAR)..DateTime.now
  CURRENT_YEAR = DateTime.now.year

 # p "IN User: CONFIG[:min_age] = '#{CONFIG[:min_age]}'. CONFIG[:max_age] = '#{CONFIG[:max_age]}'"
  MIN_AGE = CONFIG[:min_age].blank? ? nil : CONFIG[:min_age].to_i
  MAX_AGE = CONFIG[:max_age].blank? ? nil : CONFIG[:max_age].to_i 
 # p "MIN_AGE = '#{MIN_AGE}', MAX_AGE = '#{MAX_AGE}'"
  HAS_USER_EDIT_FIELDS = (CONFIG[:enable_name?] || CONFIG[:enable_gender?] || 
                          CONFIG[:enable_birthdate?] || CONFIG[:enable_time_zone?] )

#  req_name = CONFIG[:require_name?] || false
  name_can_be_blank = CONFIG[:require_name?] ? false : true
  username_can_be_blank = CONFIG[:require_username?] ? false : true
  gender_can_be_blank = CONFIG[:require_gender?] ? false : true
  birthdate_can_be_blank = CONFIG[:require_birthdate?] ? false : true
  time_zone_can_be_blank = CONFIG[:require_time_zone?] ? false : true

#  p "IN VALIDATE: gender = '#{gender}', birthdate = '#{birthdate}'"
#p "IN VALIDATE: name_can_be_blank = '#{name_can_be_blank}', CONFIG[:require_name?] = #{CONFIG[:require_name?]}'"

  has_secure_password

  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, on: :create

  validates :name, allow_blank: name_can_be_blank, presence: !name_can_be_blank, 
            format: { with: VALID_NAME_REGEX },
            length: {minimum: NAME_MIN_LENGTH, maximum: NAME_MAX_LENGTH},
            if: "CONFIG[:enable_name?]"
#  p "Validates name with maximum length of #{NAME_MAX_LENGTH}"

 #   req_username = CONFIG[:require_username?] || false
 #   p "DEFINING USERNAME. username_can_be_blank = #{username_can_be_blank}"
  validates :username, allow_blank: username_can_be_blank, presence: !username_can_be_blank, 
            format: { with: VALID_USERNAME_REGEX },
            uniqueness: { case_sensitive: false},
            length: {minimum: USERNAME_MIN_LENGTH, maximum: USERNAME_MAX_LENGTH},
            if: "CONFIG[:enable_username?]"
 
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :gender, allow_blank: gender_can_be_blank, presence: !gender_can_be_blank, 
             inclusion: { in: VALID_GENDERS },
            if: "CONFIG[:enable_gender?]"
  validates :time_zone, allow_blank: time_zone_can_be_blank, presence: !time_zone_can_be_blank, 
             inclusion: { in: ActiveSupport::TimeZone.zones_map(&:name) },
            if: "CONFIG[:enable_time_zone?]"

=begin
  def password_with_stars
    len = self.username.length
    first = username[0]
    last = username[len-1]
    first + "x"*(len-2) + last
  end 
=end

  if CONFIG[:enable_birthdate?]
#    p "IN enable_birthdate validation. MIN_AGE = #{MIN_AGE}. birthdate_can_be_blank = #{birthdate_can_be_blank}"
    date_hash = { allow_blank: birthdate_can_be_blank }
    if !MIN_AGE.nil?
      date_hash.merge!(before: Proc.new { MIN_AGE.years.ago }, before_message: "must be at least #{MIN_AGE} years old")
    end
    if !MAX_AGE.nil?
      date_hash.merge!(on_or_after: Proc.new{ MAX_AGE.years.ago }, on_or_after_message: "Cannot be more than #{MAX_AGE} years old")
    end
#    p "date_hash = #{date_hash}"
#    p "date_hash keys = #{date_hash.keys}"
    validates_date :birthdate,  date_hash
  end

#	has_secure_password
#	validates :password, length: { minimum: 6 }

  def User.username_taken?(uname)
    where(username: uname).take ? true : false
  end
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def init_unvalidated_email
    if CONFIG[:verify_email?]
      token = User.new_token
  #    p "IN INIT. token = #{token}"
      self.email_validation_token = User.hash(token)
      self.email_validated = false
    end
    self.email_changed_at = Time.zone.now
    self.email.downcase!
  end

  def reset_email(new_email)
    self.email = new_email
    init_unvalidated_email
    save!
  end

  def reset_email_validation_token(overide_token=nil)
    #helpful for testing
    token = overide_token.nil? ? User.new_token : overide_token
    hashed_token = User.hash(token)
    self.email_validation_token = hashed_token
    self.email_validated = false
    { token: token, hashed_token: hashed_token}
  end

  def send_email_validation_token
    unless self.email_validation_token
      raise "email_validation_token is not set when attempting to email the validation code"
    end
    UserMailer.email_validation_token(self).deliver
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def set_create_ip_addresses(adr)
    self.ip_address_created = self.ip_address_last_modified = adr
  end
  
  def validate_email
    self.update_attribute :email_validated, true
  end
  
  def generate_token(column, use_hash=false)
    begin
      token = use_hash ? User.hash(User.new_token) : User.new_token
      self[column] = token
    end while User.exists?(column => self[column])
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_token)
    end

    def create_validation_token
      self.validation_token = User.hash(User.new_token)
    end

    def init_new_user
      if new_record?
        init_unvalidated_email
      end
    end

end
