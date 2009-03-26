# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
use_orm :datamapper
use_test :rspec
use_template_engine :erb
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '5485aa21c4b9a1cbc1ed14f0032b7f95e3daa22f'  # required for cookie session store
  c[:session_id_key] = '_foodgenome_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # http://www.theamazingrando.com/blog/?p=34
  # This will get executed after your app's classes have been loaded.
  require 'app_config'
  AppConfig.load
end
