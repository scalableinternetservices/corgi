module ApplicationHelper
	def full_title(page_title)
	    base_title = "Corgi"
	    if page_title.empty?
	      base_title
	    else
	      "#{base_title} | #{page_title}"
    end
  end

  def profile_avatar_select(user)  
  return image_tag user.avatar.url(:medium),
                   id: 'image-preview',
                   class: 'img-responsive img-circle profile-image' if user.avatar.exists?
  image_tag 'default-avatar.jpg', id: 'image-preview',
                                  class: 'img-responsive img-circle profile-image'
  end 
end
