require 'lib/gmap.rb'

class Posts < Application

  #  provides :xml, :yaml, :js

  before :set_post_and_user

private

  def logged_in
    return self.current_user || nil
  end

  def set_post_and_user
    @current_user = self.current_user || nil
    @post = nil
    if params[:id] && params[:id].to_i > 0
      # TODO there is bug in rails where /post/list is interpreted
      #       as action = "" and id = list ... sigh.
      @post = Post.first(:id => params[:id]) if !@post
    end
    @permitted = true
  end

public

  def index
    # print out some of the users for fun onto a map
    @users = []
    User.get_all_users.each do |user|
      @map.feature( { :title => user.title, 
#                      :infoWindow => "<a href='#{URI.encode(user.link)}'>#{user.title}</a>",
                      :kind => :marker,
                      :lat => "#{user.lat}",
                      :lon => "#{user.lon}"
                    }
                   )
    end
    render
  end

  # this is a test idea; i think it would be nice to have real time ongoing tracking of participants if they want
  # so here we let them submit their information to an ordinary database for use later
  # TODO clearly icecondor and the like are also good places to submit to
  def track
    lat = params[:lat]
    lng = params[:lng]
    username = params[:username]
    password = params[:password]
    @user = User.get_user(username) # User.first(:login => username)
    @status = "Examining user"
    if @user && lat != "0" && lng != "0"
      @status = "Encoded #{lat} and #{lng} for user #{@user}"
      point = Geo.new
      point.lat = lat
      point.lon = lng
      point.user = @user.id
      point.created_at = DateTime::now
      point.save
      return "Encoded #{lat} and #{lng} for user #{user}"
   end
   @results = []
   if @user
      @status = "Points for user"
      @results = Geo.all( :limit => 10, :order => [ :created_at.desc ] )
    else
      @status = "User not found #{@user}"
    end
    render
  end

  # i'm thinking of rolling in map tracking features to amalgamate various projects
  # and here we exercise it
  # this is mostly for internal testing
  def trackview
    username = params[:username]
    password = params[:password]
    @user = User.get_user(username) # User.first(:login => username)
    @results = []
    if @user
      points = Geo.all( :limit => 4999, :order => [ :created_at.desc ], :user => @user.id )
      points.each do |p|
        @results << [ p.lat, p.lon ]
      end
    else
     @results = [
       [ 37.4419, -122.1419],
       [ 47.4519, -102.1519],
       [ 57.4619, -132.1819]
     ]
   end
   @map.feature_line(@results)
   render
  end

  def list
    render
  end

  def refresh
    @results = Post.eat_all
    render
  end

  def searches
    @promoted = 0
    render
  end

  def map
    only_provides :html
    render
  end

  def show
    raise NotFound unless @post
    render :show
  end

  def recent
    render
  end

  def similar
    render
  end

end
