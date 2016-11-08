module UsersHelper

	# Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 80})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def cache_key_for_user_info(user)
  	if current_user?(user)
  		"user-info-#{user.id}-#{user.updated_at}-current"
  	elsif current_user.following?(user)
  		"user-info-#{user.id}-#{user.updated_at}-following"
  	else
  		"user-info-#{user.id}-#{user.updated_at}-not"
  	end
  end
  
end
