Merb.logger.info("Compiling routes...")

Merb::Router.prepare do |r|
 
  r.resources :posts
  r.resources :users
 
  r.match('/').to(:controller => 'posts', :action =>'index')

  r.match('/login').to(       :controller  => 'users', :action =>'signin')
  r.match('/signin').to(      :controller  => 'users', :action =>'signin')
  r.match('/logout').to(      :controller  => 'users', :action =>'signout')
  r.match('/signout').to(     :controller  => 'users', :action =>'signout')
  r.match('/logup').to(       :controller  => 'users', :action =>'signup')
  r.match('/signup').to(      :controller  => 'users', :action =>'signup')
  r.match('/forgot').to(      :controller  => 'users', :action => 'forgot')
  r.match('/change').to(      :controller  => 'users', :action => 'change')
  r.match('/invite').to(      :controller  => 'users', :action => 'invite')
  r.match('/participants').to(:controller  => 'users', :action => 'index' )

  r.match('/help').to(    :controller => 'site',    :action => 'help' )
  r.match('/about').to(   :controller => 'site',    :action => 'about' )
 
  r.match('/refresh').to(  :controller => 'posts',   :action => 'refresh' )
  r.match('/search').to(  :controller => 'posts',   :action => 'search' )
  r.match('/advanced').to(:controller => 'posts',   :action => 'advanced' )
  r.match('/add').to(     :controller => 'posts',   :action => 'add' )
  r.match('/added').to(   :controller => 'posts',   :action => 'added' )
  r.match('/edit').to(    :controller => 'posts',   :action => 'edit' )
  r.match('/similar').to( :controller => 'posts',   :action => 'similar' )
  r.match('/searches').to(:controller => 'posts',   :action => 'searches'  )
  r.match('/recent').to(  :controller => 'posts',   :action => 'recent' )
  r.match('/list').to(    :controller => 'posts',   :action => 'list' )
  r.match('/map').to(     :controller => 'posts',   :action => 'map' )
  r.match('/track').to(   :controller => 'posts',   :action => 'track' )
  r.match('/trackview').to(   :controller => 'posts',   :action => 'trackview' )

  r.match('/services/upload').to(:controller => 'emails',   :action => 'services' )

  r.default_routes

end

