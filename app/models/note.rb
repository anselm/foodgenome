
#
# unique edges on nodes used to form tagging and relationships
# stores name, value, provenance
# is unique per node so two different nodes would have the same tag 'purple' independently
# ie you have to do 'select note_id from relations where kind = 'tag' && value == 'purple' ...
#
class Relation
  include DataMapper::Resource

  RELATION_TWITTER_SCREEN_NAME = "twitter:screen_name"
  RELATION_OWNER               = "owner"
  RELATION_TAG                 = "tag"

  belongs_to :note
#  belongs_to :sibling - this crashes - so leave it commented out

  property   :id,         Integer, :serial => true
  property   :kind,       String, :default => ""
  property   :value,      Text, :default => nil
  property   :created_at, DateTime
  property   :updated_at, DateTime
  property   :note_id,    Integer   # mandatory
  property   :sibling_id, Integer   # optional - used to create edges between nodes

end

#
# A base class that allows relationships
#
class Note
  include DataMapper::Resource
  include DataMapper::Validate

  KIND_USER = "user"
  KIND_POST = "post"
  KIND_FEED = "feed"

  has n,   :relations

  property :id,                        Integer, :serial => true   # unique per note
  property :type,                      Discriminator
  property :uuid,                      Text                       # a unique key per note
  property :title,                     Text                       # rss
  property :link,                      Text                       # rss
  property :description,               Text                       # rss
  property :tagstring,                 Text                       # rss
  property :depiction,                 Text                       # rss
  property :location,                  Text                       # rss
  property :lat,                       Float, :default => 0       # rss
  property :lon,                       Float, :default => 0       # rss
  property :radius,                    Float, :default => 1       # rss
  property :begins,                    DateTime                   # rss
  property :ends,                      DateTime                   # rss
  property :permissions,               Integer, :default => 1     # permissions
  property :kind,                      String, :default => ""
  property :created_at,                DateTime
  property :updated_at,                DateTime
  property :owner_id,                  Integer  # optionally allow a hierarchy - important where 'users' own 'notes'

end


#
# note relation management
#
class Note

  def relation_get(kind, sibling_id = nil)
    r = nil
    if sibling_id
      r = Relation.first(:note_id => self.id, :kind => kind, :sibling_id => sibling_id )
    else
      r = Relation.first(:note_id => self.id, :kind => kind )
    end
    return r.value if r
    return nil 
  end

  def relation_first(kind, sibling_id = nil)
    r = nil
    if sibling_id
      r = Relation.first(:note_id => self.id, :kind => kind, :sibling_id => sibling_id )
    else
      r = Relation.first(:note_id => self.id, :kind => kind )
    end
    return r
  end

  def relation_all(kind = nil, sibling_id = nil)
    results = Relation.all(:note_id => self.id)
    results = results.all(:kind => kind) if kind
    results = results.all( :sibling_id => sibling_id ) if sibling_id
    return results
  end

  def relation_destroy(kind = nil, sibling_id = nil)
    results = Relation.all(:note_id => self.id)
    results = results.all(:kind => kind) if kind
    results = results.all(:sibling_id => sibling_id ) if sibling_id
    results.destroy!
  end

  def relation_add(kind, value, sibling_id = nil)
    relation_destroy(kind,sibling_id)
    return if !value
    Relation.create!({
                 :note_id => self.id,
                 :sibling_id => sibling_id,
                 :kind => kind,
                 :value => value.to_s.strip
               })
  end

  def relation_add_array(kind,value,sibling_id = nil)
    relation_destroy(kind,sibling_id)
    return if !value
    value.each do |v|
      Relation.create!({
                   :note_id => self.id,
                   :sibling_id => sibling_id,
                   :kind => kind,
                   :value => v.strip
                 })
    end
  end

=begin
    ##########################################################################################
    # treat extended variables as a hash; as a substitute for a slower separate table approach
	# unused
    ##########################################################################################

    def []=(a,b)
      if a && self.has_attribute?(a)
        super(a,b)
      else
        self.extended = {} if !self.extended || !self.extended.is_a?(Hash)
        self.extended[a.to_s] = b
      end
    end

    def [](a) 
      if a
        return super(a) if self.has_attribute?(a)
        return self.extended[a.to_s] rescue nil
      end
      return nil
    end

=end

end

