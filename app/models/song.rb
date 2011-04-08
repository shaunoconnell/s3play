class Song < ActiveRecord::Base
	# has_attached_file :song_binary, :url => "/:class/:attachment/:id/:basename.:extension"
	
	has_attached_file :song_binary,
		:storage => :s3,
    	:s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    	:path => ":attachment/:id/:style.:extension",
    	:bucket => "binary_songs"
end
