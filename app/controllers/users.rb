
class Users < Application

  before :block_if_no_user_by_id?, :only => %w[ :edit :update show :forgot ]
  before :block_if_not_logged_in?, :only => %w[ :edit :update :destroy :change ]
  before :block_if_no_edit_privs?, :only => %w[ :edit :update :destroy ]

  def block_if_no_user_by_id?
    @user = User.first(:login => params[:id])
    @@user = @user
    return @user
    # fail if a user is not found as part of the url request parameter
    # TODO this code is poorly written and verbose for what it does
    @user_visiting_self = false
    @user = nil
    return nil if !params[:id]
    params[:id].to_a.each do |s|
      begin
        @user = User.first(:login => s)
      rescue
      end
      begin
        @user = User.first(:id => s ) if !@user
      rescue
      end
    end
    return @user || nil
  end

  def block_if_not_logged_in?
    # in some cases we wish to block access if the user is not logged in via a cookie etc
    # is the user looking at a page about themselves?
    self.current_user
    @user_visiting_self = false
    if self.current_user && @user && self.current_user.login == @user.login
      @user_visiting_self = true
    end
    # is the user logged in?
    return true if self.current_user
    flash[:warning]='Please login to continue'
    session[:return_to]=request.request_uri
    redirect url(:signin)
    return false
  end

  def block_if_no_edit_privs?
    # fail if the user being operated on does not have privs for this operation
    # TODO later allow admin to edit other users
    return true if @user_visiting_self  # || ( self.current_user && self.current_user.is_admin? )
    flash[:warning]='Please login to continue'
    session[:return_to]=request.request_uri
    redirect url(:signin)
    return false
  end

  ###########################################################################

  def signin
    only_provides :html
    if request.post?
      user = User.authenticate(params[:user][:login], params[:user][:password])
      if session_start(user)
        redirect_back_or_default('/')
        flash[:notice] = "Logged in successfully"
        return " "  # TODO how do you tell merb to render nothing?
      end
      session_stop
      flash[:warning] = "Whoops! Your name or password wasn't recognized"
    end
    @user = User.new
    render
  end

  def signout
    session_stop
    #flash[:notice] = "You have been logged out."
    render
    # redirect_back_or_default('/')
  end
  
  ###########################################################################

  def index
    @users = User.all
    display @users
  end

  def show
    return "No user found for name #{params[:id]} #{@@user} ... #{@user}" if !@user
    @current_user = self.current_user
    display @user
  end

  def signup
    only_provides :html
    @user = User.new
    render
  end

  def edit
    only_provides :html
    raise NotFound unless @user
    render
  end

  def create
    # TODO captcha
    # TODO - it would be slightly more elegant to downcase in users
    # TODO - save depiction
    # TODO - slightly more elegant to push this to the authenticated module

    params[:user][:login] = params[:user][:login].downcase
    @user = User.new(params[:user])
    if !@user.save
      flash[:warning] = "Problem creating account #{@user.errors}"
      render :signup
      return
    end
    session_start(@user)
    
    send_email(nil,nil,
      "",@user.email,
      "Welcome to #{SITE_NAME}!",
      "Welcome #{@user.login}!"
    );
/*
    send_email(nil,nil,nil,SITE_EMAIL,
      "Notice: New user: name, email #{@user.login}, #{@user.email}",
      "A new user has registered"
    );
*/
    flash[:notice] = 'Thanks for signing up.'
    redirect "/users/#{@user.login}"
  end

  def update
    # TODO handle uploaded image
    raise NotFound unless @user
    if @user.update_attributes(params[:user]) || !@user.dirty?
      redirect "/users/#{@user.login}"
    else
      raise BadRequest
    end
  end

  def destroy
    # TODO disabled until we think it through - prefer to use a flag not a perm deletion
    # TODO destroy dependencies cascade
    # TODO don't let you destroy other users
    # TODO block on doing this by accident
    # raise NotFound unless @user
    # if @user.destroy
    #  redirect url("/");
    # else
    #  raise BadRequest
    # end
  end

  def forgot
    # TODO we need to make artwork for a forgot password page
    # TODO hmm, this pattern harasses users; can we just send a reminder?
    # TODO we could send them a temporary link
    if request.post?
      u = User.first(:email => params[:user][:email])
      if u
        pass = u.set_new_password
          @user = u
          send_email(nil,nil,
             "",@user.email,
             "Somebody, perhaps even you reset your password",
             "The new password for #{@user.login} is #{pass}"
          );
        flash[:message]  = "A new password has been sent by email."
        redirect url(:signin)
      else
        flash[:warning]  = "Couldn't send password"
      end
    end
  end

  def change
    # TODO finish
    if request.post?
      @user = self.current_user
      @user.password = params[:user][:password]
      if @user.save
        send_email(nil,nil,
           "",@user.email,
           "You changed your password",
           "The new password for #{@user.login} is #{params[:user][:password]}"
        );
        flash[:message]="Password Changed"
        redirect url(:signin)
      end
    end
  end

end


