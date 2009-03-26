
# A minimalist class for tracking tracklogs

class Geo
  include DataMapper::Resource
  include DataMapper::Validate

  property :id,                      Integer, :serial => true   # unique per note
  property :lat,                       Float, :default => 0       # rss
  property :lon,                       Float, :default => 0       # rss
  property :user,                    Integer, :default => 0
  property :created_at,                DateTime

end


