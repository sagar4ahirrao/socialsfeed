class FeedsController < ApplicationController
def facebook
Koala.config.api_version = "v2.0"
if current_user.identities
 identity = current_user.identities.find_by_provider("facebook")
    if identity
    @facebook ||= Koala::Facebook::API.new(identity.accesstoken)
    @profile = @facebook.get_object("me")
	@picture = @facebook.get_picture("me")
	@feed = @facebook.get_connections("me","feed")
	@friends = @facebook.get_connections("me", "friends")
 end
	else
		redirect_to "/"
	end
end 



def twitter
   if current_user.identities
 identity = current_user.identities.find_by_provider("twitter")
    if identity

 client = Twitter::REST::Client.new do |config|
  config.consumer_key        = Rails.application.config.twitter_key
  config.consumer_secret     = Rails.application.config.twitter_secret
  config.access_token        = identity.accesstoken 
  config.access_token_secret = identity.secret
 end
 
 @tweets = client.user_timeline(page: 1, count: 20)
 @posts = client.home_timeline(page: 1, count: 20)
 # client.update(@tweet)
    end
	else
		redirect_to "/"
	end
    #$client.update("hey dude whatsup?!")
  # @tweets = client.user_timeline(page: 1, count: 50)  
end

end
