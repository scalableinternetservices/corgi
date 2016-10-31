module EventsHelper
	def map_image(event)
		image_tag "https://maps.googleapis.com/maps/api/staticmap?center=#{event.latitude},#{event.longitude}&zoom=14&size=750x400&markers=color:blue%7clabel:S%7c#{event.latitude},#{event.longitude}&path=weight:3%7Ccolor:blue%7Cenc:{coaHnetiVjM??_SkM??~R&key=AIzaSyCp2SxzPnilWMAFfvo3QTr-EBCobz_dh6Y"
	end

  	def events_picture_select(event)
    	if event.picture.exists?
      		image_tag event.picture.url(:large), id: 'image-preview', class: 'img-responsive profile-image' 
    	else
      		image_tag 'default-event.png', id: 'image-preview', class: 'img-responsive profile-image'
   		end  
  	end
end
