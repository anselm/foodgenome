require 'net/smtp'
require 'net/http'
require 'uri'
require 'json'

require 'lib/dynamapper.rb'

class Application < Merb::Controller

  before :dynamapper_initialize
  # before :detect_iphone

  def dynamapper_initialize
    @map = Dynamapper.new
  end

  def detect_iphone
    if request.env["HTTP_USER_AGENT"]
      if request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
        # ignore for now
        # request.format = :iphone
      end
    end
  end

  #####################################################################
  #
  # I think I will keep some globals here for now? TODO
  #
  #####################################################################

  SITE_NAME = "FoodGenome"
  SITE_URL = "foodgenome.com"
  SITE_TWITTER_USERNAME = "foodgenome"
  SITE_TWITTER_PASSWORD = "secret"
  SITE_EMAIL = "twitter@foodgenome.com"
  SITE_INTERNAL_EMAIL = "foodgenome@googlegroups.com"  # for internal status updates
  SITE_USER_EMAIL = "unknown@unknown.com" # for when we don't know somebodys email	
  SITE_METACARTA_USERID = "anselm" 
  SITE_METACARTA_PASS = "secret"

  #####################################################################
  #
  # geolocate something by brute force scanning of text... using metacarta
  #
  #####################################################################


	# TODO i'm not really sure that these kinds of utilities belong inside the model... but unsure where to put them.
	# a utility method to geolocate a string using the metacarta brute force geolocation engine
	# TODO please put a time out check on this.
	def geolocate(location)
		key = "f94d9fe40481b0a044edc8f729724335"
		location = URI.escape(location, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
		# location = CGI.escape(location)
		# location = URI.escape(location)
		host = "ondemand.metacarta.com"
		path = "/webservices/GeoTagger/JSON/basic?version=1.0.0"
		path = "#{path}&doc=#{location}"
		data = {}
		begin
			req = Net::HTTP::Get.new(path)
			req.basic_auth SITE_METACARTA_USERID, SITE_METACARTA_PASSWORD
			http = Net::HTTP.start(host)
			#if response.is_a?(Net::HTTPSuccess)
				response = http.request(req)
				data = JSON.parse(response.body)
			#end
		rescue Timeout::Error
			# DO SOMETHING WISER
			return 0,0
		rescue
			return 0,0
		end
		begin
			lat = data["Locations"][0]["Centroid"]["Latitude"]
			lon = data["Locations"][0]["Centroid"]["Longitude"]
			return lat,lon
		rescue
		end
		return 0,0
	end

  #####################################################################
  #
  # Send an email... leave this method here for now?
  #
  #####################################################################

	def self.foodgenome_suggest(request)

# TODO DO NOT DO HERE
# TODO store in our database what we actually get back

		request = request.gsub(/[\#\?\&\=\@\%]/,' ')
		request = URI.escape(request, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
		request = request.strip

		host = "www.foodgenome.com"
		path = "/api/suggest.json?query=#{request}"
		data = {}
		begin
			req = Net::HTTP::Get.new(path)
			http = Net::HTTP.start(host)
			response = http.request(req)
			data = JSON.parse(response.body)
			return data
		rescue Timeout::Error
		end
		return "failed"
	end

  #####################################################################
  #
  # Send an email... leave this method here for now?
  #
  #####################################################################


  def send_email(from_name,from_email,to_name,to_email,subject,body)
    # TODO replace with something bulkier and more of a hassle later?
    # TODO it is overspecialized to use the domain name here
    from_domain = "foodgenome.com"
    if !from_name || from_name.length < 1
      from_name = "twitter"
      from_email = "twitter@#{from_domain}"
    end
    begin
      message = "From: #{from_name} <#{from_email}>\n" +
                "To: #{to_name} <#{to_email}>\n" +
                "Subject: #{subject}\n" +
                "#{body}\n"
      Net::SMTP.start('localhost') do |smtp|
        smtp.send_message message, from_email, to_email
      end
    rescue
      # TODO if the email fails we can use this to filter bad users
    end
  end

  #####################################################################
  # common user session utilities
  # TODO move to a library or slice later on or use the merbauth
  # TODO think about the pattern of rails MVC => it fails to let one concentrate roles
  # TODO I kind of would like session management associated with user... but dunno... unclear.
  #####################################################################

  def logged_in?
    return true if self.current_user
    return false
  end

  def authorized?
    # TODO improve to deal with admin areas and the like
    logged_in? || throw(:halt, :access_denied)
  end 

  def access_denied
    case content_type
    when :html
      session[:return_to] = request.uri
      redirect url(:login)
    when :xml
      headers["Status"] = "Unauthorized"
      headers["WWW-Authenticate"] = %(Basic realm="Web Password")
      self.status = 401
      render "Could not authenticate you"
    end
  end

  def is_admin?
    return true if self.current_user && self.current_user.is_admin?
    access_denied
    return false
  end

  def current_user
    @current_user = login_from_session if !@current_user
    @current_user = login_from_cookie if !@current_user
    return @current_user || false
  end

  def login_from_session
    user = nil
    user = User.first(:id => session[:user]) if session[:user]
    session_start(user)
  end

  def login_from_cookie
    user = nil
    user = User.first(:remember_token => cookies[:auth_token] ) if cookies[:auth_token]
    session_start(user)
  end

  def session_start(user)
    @current_user = (user.nil? || user.is_a?(Symbol)) ? nil : user
    session[:user] = (user.nil?) ? nil : user.id
    if user && user.remember_token?
      user.remember_me
      cookies[:auth_token] = {
                      :value => user.remember_token ,
                      :expires => user.remember_token_expires_at
                     }
    end
    return user || false
  end 
 
  def session_stop
    @current_user.forget_me if @current_user
    cookies.delete :auth_token
    @current_user = nil
    session[:user] = nil
  end

  def store_location
    session[:return_to] = request.uri
  end
    
  def redirect_back_or_default(default)
    location = session[:return_to] || default
    session[:return_to] = nil
    redirect location
  end

  #####################################################################
  # let a user login from http auth
  # unused right now
  #####################################################################

  # admin area password stuff
  def get_auth_data 
    auth_data = nil
    [
      'REDIRECT_REDIRECT_X_HTTP_AUTHORIZATION',
      'REDIRECT_X_HTTP_AUTHORIZATION',
      'X-HTTP_AUTHORIZATION', 
      'HTTP_AUTHORIZATION'
    ].each do |key|
      if request.env.has_key?(key)
        auth_data = request.env[key].to_s.split
        break
      end
    end
    if auth_data && auth_data[0] == 'Basic' 
      return Base64.decode64(auth_data[1]).split(':')[0..1] 
    end 
  end

  # ask for administrative access
  def authorize
    if session["allcool"] == 1
      return true
    end
    login,password = get_auth_data
    @test = User.find_by_login(login)
    if @test && @test.authenticated?(password) # && @test.is_admin
      session["allcool"] = 1
      return true
    end
    session["allcool"] = 0
    headers["Status"] = "Unauthorized" 
    headers["WWW-Authenticate"] = 'Basic realm="Realm"'
    self.status = 401
    render "Authentication Required"
    return false
  end

  # Inclusion hook to make #current_user_model and #logged_in?
  # available as ActionView helper methods.
  # def self.included(base)
  #   base.send :helper_method, :current_user, :logged_in?
  # end

end



