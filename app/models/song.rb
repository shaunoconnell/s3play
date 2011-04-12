class Song 
	# has_attached_file :song_binary, :url => "/:class/:attachment/:id/:basename.:extension"
	include Mongoid::Document
	include Mongoid::Paperclip

	has_mongoid_attached_file :song_binary,
		:storage => :s3,
    	:s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    	:path => ":attachment/:id/:basename.:extension",
    	:s3_permissions => "private", 
    	:bucket => "binary_songs"
	
	# has_attached_file :song_binary,
	# 	:storage => :s3,
	#     	:s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
	#     	:path => ":attachment/:id/:basename.:extension",
	#     	:s3_permissions => "private", 
	#     	:bucket => "binary_songs"
   field :name, :type => String
   field :song_binary_file_name, :type => String
   field :song_binary_content_type, :type => String # Mime type
   field :song_binary_file_size, :type => String # File size in bytes
    	
   after_create :extract_tag_data
  	def extract_tag_data
  		#TODO: lets see if we can grab tag data here.
  		
  		#TODO: make functions for file manipulations
  		puts "s_b.class: #{song_binary.class} \n song_binary: #{song_binary}"
  		puts "id=> #{id}"
  		require "mp3info"
  		# Mp3Info.open(song_binary) do |mp3|
  		#     		puts mp3.tag.title   
  		#     		puts mp3.tag.artist   
  		#     		puts mp3.tag.album
  		#     		puts mp3.tag.tracknum
  		# end
  		# 
  		path_to_store_file_to = "#{Rails.public_path}/tmpmusic/#{id}"
  		Dir.mkdir path_to_store_file_to unless Dir.exists? path_to_store_file_to
  		
  		puts "---- #{path_to_store_file_to}"
  		puts "---- #{path_to_store_file_to}/#{song_binary.original_filename}"
  		
  		
			#   		open("#{path_to_store_file_to}/#{song_binary.original_filename}", 'wb') do |file|
			#   			AWS::S3::S3Object.stream(song_binary.path,"binary_songs") do |chunk|
			#   			 	file.write chunk
			#   			end
			#   		end
			#   		
			#   		Mp3Info.open("#{path_to_store_file_to}/#{song_binary.original_filename}") do |mp3|
			# puts mp3.tag.title   
			#   			puts mp3.tag.artist   
			#   		    puts mp3.tag.album
			#   		    puts mp3.tag.tracknum
			#   		end
  	end

    	
   #Fails?
   def before_song_binary_post_process
   	puts "before paperclip processing. . .. ."
   end
   
   def after_song_binary_post_process
   	puts ". . . .after paperclip processing"	
   end
end
