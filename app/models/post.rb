require 'twitter'

class Post < Note

	POST_RESPONDED = 1
	POST_UNRESPONDED = 0
	
	def self.eat_all
		self.eat_posts_twitter
		self.posts_respond_all
	end

	def self.eat_posts_twitter
		results = []
		site_twitter_username = Merb::Config[:site_twitter_username]
		site_twitter_password = Merb::Config[:site_twitter_password]
		twitter = Twitter::Base.new(site_twitter_username,site_twitter_password)
		twitter.replies().each do |twit|

			post = Post.first(:uuid => "twitter_#{twit.id}")
			next if post

puts "post not found #{twit.id}"
			user = User.search(
					:provenance => "twitter",
					:uniquename => twit.user.id
					)
puts "found user #{user}"

			if !user
puts "did not find user #{twit.user.screen_name}"
				user = User.create_user_or_update(
					:provenance => "twitter",
					:uniquename => twit.user.id,
					:screenname => twit.user.screen_name,
					# :link => twit.user.link,
					:location => twit.user.location,
					:description => twit.user.description,
					#:depiction => twit.user.depiction,
					:permissions => User::PERMISSIONS_DISABLED,  # force the account to be disabled
					:password => "none"  # might as well set this to garbage for now.
					)
puts "made user #{user}"
				results << user.title
			else
puts "user was found already"
				results << "already friended #{twit.user.screen_name}"
				# the user can change their fricking name
				user.screenname = twit.user.screen_name
				user.location = twit.user.location
				user.description = twit.user.description
				user.save
			end

			post = self.eat_post_save(
					:uuid => "twitter_#{twit.id}",
					:provenance => 'twitter',
					:location => twit.user.location,
					:text => twit.text,
					:userid => user.id
					)

		end
	end
	
	def self.sanitize(text)
		# TODO remove bad things
		text = text[11..-1] if text[0..10] == "@foodgenome" 
		text = text[12..-1] if text[0..11] == "d foodgenome" 
		return text
	end

	def self.eat_post_save(args)
		uuid = args[:uuid]
		provenance = args[:provenance]
		location = args[:location]
		text = args[:text]
		text = self.sanitize(text)
		userid = args[:userid]
		post = Post.first(:uuid => uuid)
		return post if post
		# save post
		post = Post.create!(
			:kind => Note::KIND_POST,
			:uuid => uuid,
			:title => text,
			:owner_id => userid,
			:created_at => DateTime::now,
			:updated_at => DateTime::now,
			:permissions => POST_UNRESPONDED
			# in_reply_to_user_id
			# created_at
			# source
			# in_reply_to_status_id
			# truncated
			# favorited
			)
		# save post tags
		post.relation_add(Relation::RELATION_OWNER,userid)
		text.scan(/#[a-zA-Z]+/i).each do |tag|
			post.relation_add(Relation::RELATION_TAG,tag[1..-1])
		end
		return post
	end

	def self.posts_respond_all
		results = []
		Post.all(:permissions => POST_UNRESPONDED).each do |post|
 puts "responding to all posts on post #{post.id}"
			user = User.first(:id => post.owner_id)
 puts "found user #{post.owner_id}"
			result = self.eat_post_respond(user,post)
			if result
 puts "did respond well"
				post.permissions = POST_RESPONDED
				post.save!
				results << result
			else
 puts "failed to respond well"
				results << "failed to save post"
			end
		end
		return results
	end

	def self.eat_post_respond(user,post)
		self.eat_post_befriend_twitter(user)
		return self.eat_post_twitter(user,post)
	end

	def self.eat_post_twitter(user,post)
		twitter_username = Merb::Config[:site_twitter_username]
		twitter_password = Merb::Config[:site_twitter_password]
		twitter = Twitter::Base.new(twitter_username,twitter_password)

		# locally publish the event
		if false
			message = "via #{user.login} #{post.title}"
			response = twitter.post(message)
		end

		# LATER:
		#	handle a variety of requests such as yum and yuck

		# FOR NOW:
		#	just respond with some good suggestions on food supplied
		results = Application::foodgenome_suggest(post.title)
		if results
			# twitter.d(user.title,message)

puts "*********************"
pretty = "@#{user.title} "
results = results["results"]
if results
results.each do |recipe|
 pretty = "#{pretty} #{recipe['name']} * "
end
pretty = pretty[0..135]
message = pretty
end

			twitter.post(pretty) if pretty.length > 100
		end




		return message
	end

	#
	# We locally track if a user is friended already
	# We can get out of sync with twitter so we have to check until we get a match
	# Also we will throw an error if we try to friend if already friends so check first
	# TODO this should only be invoked if provenance is twitter
	#
	def self.eat_post_befriend_twitter(user)
		if( user.permissions & User::PERMISSIONS_FRIENDED == 0 ) 
			begin
				twitter_username = Merb::Config[:site_twitter_username]
				twitter_password = Merb::Config[:site_twitter_password]
				twitter = Twitter::Base.new(twitter_username,twitter_password)
				if twitter.friendship_exists?(twitter_username,user.title)
					user.permissions = User.PERMISSIONS_FRIENDED + USER.PERMISSIONS_NOTADMIN;
					user.save!
				else
					twitter.create_friendship(user.title)
					user.permissions = User.PERMISSIONS_FRIENDED + USER.PERMISSIONS_NOTADMIN;
					user.save!
				end
			rescue
			end
		else
		end
	end

end


