
require 'digest/sha1'

class User < Note

  PERMISSIONS_DISABLED = 0
  PERMISSIONS_NOTADMIN = 1
  PERMISSIONS_FRIENDED = 128	# friended on twitter ... not totally hygenic separation of meaning TODO
  PERMISSIONS_ADMIN = 32768

  # facts specific to users
  property :login,                     String
  property :email,                     String
  property :firstname,                 String
  property :lastname,                  String
  property :crypted_password,          String
  property :salt,                      String
  property :remember_token,            String
  property :remember_token_expires_at, Time

  attr_accessor         :password
  validates_present     :login, :email
  validates_present     :password,                   :if => :password_required?
  validates_length      :password, :within => 4..40, :if => :password_required?
  # validates_present   :password_confirmation,      :if => :password_required?
  # validates_confirmation_of :password,              :if => :password_required?
  validates_length      :login,    :within => 3..32
  validates_length      :email,    :within => 3..100
  validates_is_unique   :login,    :email, :case_sensitive => false
  validates_format      :login,
                          :with => /^([a-z0-9_]+){0,2}[a-z0-9_]+$/i,
                          :on => :create,
                          :message => "can only contain letters and digits"
  validates_format      :email,
                          :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
                          :message => "Invalid email"  
  before :save,           :encrypt_password
  before :save,           :fill_fields

  def self.get_all_users
   return Users.all
  end

  def self.authenticate(login, password)
    u = User.first(:login => login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  def remember_me
    remember_me_for Merb::Const::WEEK * 2
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token = encrypt("#{email}--#{remember_token_expires_at}")
    save # (false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save # (false)
  end

  def set_new_password
    new_pass = User.random_string(10)
    # self.password = self.password_confirmation = new_pass
    self.password = new_pass
    self.save
    return new_pass
    #Notifications.deliver_forgot_password(self.email, self.login, new_pass)
  end

  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def to_s; login end

  def is_admin?
    # TODO use an enum
    return self.permissions == 3
  end

  def is_enabled?
	return self.permission && self.permission > 0
  end

protected

  def encrypt_password
    return if password.blank?
    self.salt =Digest::SHA1.hexdigest("#{Time.now.to_s}#{login}") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end

end


#
# higher level user concepts 
#
class User

  # a helper - since we've pushed logic into meta schemas rather than directly into the db
  # TODO should we return the right type? should we on just users?
  # TODO uh this method is stupid... it is legacy due to notes concept base class.
  def self.get_all_users
    return User.all(:kind => Note::KIND_USER)
  end

  # a helper - since we've pushed logic into meta schemas rather than directly into the db
  # TODO should we return the right type? should we search on just users?
  # TODO this is legacy remove
  def self.get_user(name)
    return User.first(:kind => Note::KIND_USER, :title => name )
  end

  def fill_fields
    # TODO i would prefer to overload create! and fold with below... this is a workaround.
    self.kind = Note::KIND_USER
    self.title = self.login if !self.title
  end

  def self.search(args={})
	provenance = args[:provenance] || "local"
	uniquename = args[:uniquename]
	uuid = "#{provenance}#{uniquename}"
	return User.first(:uuid => uuid )
  end

  # TODO this should fold with above and be only create method - must intercept create! method.
  def self.create_user_or_update(args={})

	 provenance = args[:provenance] || "local"
     uniquename = args[:uniquename]
     screenname = args[:screenname]
     link = args[:link]
     location = args[:location]
     depiction = args[:depiction]
     description = args[:description]
	 permissions = args[:permissions] || 0
	 password = args[:password] || "secret"

	 uuid = "#{provenance}#{uniquename}"
     user = User.first(:uuid => uuid )

     if !user
        user = User.create!(
            :login       => uuid,
            :uuid        => uuid,
            :title       => screenname,
            :link        => link,
			:location	 => location,
            :description => description,
            :depiction   => depiction,				# TODO this fails sadly
            :created_at  => DateTime::now,
            :updated_at  => DateTime::now,
			:permissions => permissions,
            :email       => Application::SITE_USER_EMAIL,		# TODO we don't know this always
            :firstname   => "",						# TODO we don't know this always
            :lastname    => "",						# TODO we don't know this always
            :password	 => password,				# TODO mark the account as inactivated
            :kind        => User::KIND_USER
         )

		# this was a thought to track information via extended attributes but no real need for it atm
		# n.relation_add(Relation::RELATION_TWITTER_SCREEN_NAME,screenname ) if user

     end
  
	 # update changes to existing user
	 if user && location && location.length > 0 && location != user.location
       user.location = twitter_user.location
       user.lat,user.lon = global_geolocate(n.location)
       user.save!
     end

     return user

   end

end

