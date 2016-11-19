module EventsHelper
	def map_image(event)
		image_tag "https://maps.googleapis.com/maps/api/staticmap?center=#{event.latitude},#{event.longitude}&zoom=14&size=750x400&markers=color:blue%7clabel:S%7c#{event.latitude},#{event.longitude}&path=weight:3%7Ccolor:blue%7Cenc:{coaHnetiVjM??_SkM??~R&key=AIzaSyCp2SxzPnilWMAFfvo3QTr-EBCobz_dh6Y"
	end

  	def events_picture_select(event)
    	if event.picture.exists?
      	image_tag event.picture.url(:large), id: 'image-preview', class: 'img-responsive events-image' 
    	else
      	image_tag 'default-event.png', id: 'image-preview', class: 'img-responsive events-image'
   		end  
  	end

  def cache_key_for_event(event)
    if event.guests.count > 0
      newest_relationship = Invite.where(:event_id => event.id).maximum(:created_at)
      "event-#{event.id}-#{event.updated_at}-comments#{event.comments.count}-guests#{event.guests.count}-#{newest_relationship}"
    else
      "event-#{event.id}-#{event.updated_at}-comments#{event.comments.count}"
    end
  end

  def cache_key_for_event_info(event)
    if event.guests.count > 0
      newest_relationship = Invite.where(:event_id => event.id).maximum(:created_at)
      "event-info-#{event.id}-#{event.updated_at}-guests#{event.guests.count}-#{newest_relationship}"
    else
      "event-info-#{event.id}-#{event.updated_at}"
    end
  end

  def cache_key_for_event_map(event)
    "event-map-#{event.id}-#{event.location}"
  end
end
