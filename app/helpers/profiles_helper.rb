module ProfilesHelper
	def cache_key_for_profile(user)
		if current_user?(user)
			"profile-#{user.id}-#{user.updated_at}-current"
		elsif current_user.following?(user)
			"profile-#{user.id}-#{user.updated_at}-following"
		else
			"profile-#{user.id}-#{user.updated_at}-not"
		end
	end
end
