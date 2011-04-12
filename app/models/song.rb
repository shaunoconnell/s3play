class Song < ActiveRecord::Base
	# has_attached_file :song_binary, :url => "/:class/:attachment/:id/:basename.:extension"
	include Mongoid::Document
	
	has_attached_file :song_binary,
		:storage => :s3,
    	:s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    	:path => ":attachment/:id/:basename.:extension",
    	:s3_permissions => "private", 
    	:bucket => "binary_songs"
    	
   field :song_binary_file_name, :type => String
   field :song_binary_content_type, :type => String # Mime type
   field :song_binary_file_size, :type => String # File size in bytes
    	
   before_create :extract_tag_data
  	def extract_tag_data
  		#TODO: lets see if we can grab tag data here.
  		
  		puts "s_b: #{song_binary}"
  	end

    	
   #Fails?
   def before_song_binary_post_process
   	puts "before paperclip processing. . .. ."
   end
   
   def after_song_binary_post_process
   	puts ". . . .after paperclip processing"	
   end
end
