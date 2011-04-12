class SongsController < ApplicationController
  # GET /songs
  # GET /songs.xml
  def index
    @songs = Song.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.xml
  def show
    @song = Song.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @song }
    end
  end

  # GET /songs/new
  # GET /songs/new.xml
  def new
    @song = Song.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song }
    end
  end

  # GET /songs/1/edit
  def edit
    @song = Song.find(params[:id])
  end

  # POST /songs
  # POST /songs.xml
  def create
    @song = Song.new(params[:song])
 
	puts "getting read to do the respond_to"
    respond_to do |format|
 	  puts "prepping save"    
 	  save_result = @song.save
 	  puts " . .. . have save_result #{save_result}"
      if save_result
      	puts " save succesful"
        format.html { redirect_to(@song, :notice => 'Song was successfully created.') }
        format.xml  { render :xml => @song, :status => :created, :location => @song }
      else
      	puts "FAILURE for save!"
        format.html { render :action => "new" }
        format.xml  { render :xml => @song.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /songs/1
  # PUT /songs/1.xml
  def update
    @song = Song.find(params[:id])

    respond_to do |format|
      if @song.update_attributes(params[:song])
        format.html { redirect_to(@song, :notice => 'Song was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @song.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.xml
  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to(songs_url) }
      format.xml  { head :ok }
    end
  end
  
  def music
  	puts "id: #{params[:id]}"
  	@song = Song.find(params[:id])
  	puts @song
  	puts " s3 path: #{@song.song_binary.path}"
  	puts "song.id #{@song.id}"
  	#TODO catch not found exception
  	# s3_value = AWS::S3::S3Object.value(@song.song_binary.path,"binary_songs")
  	# 
  	# @song.song_binary.stream_to s3_value, "#{Rails.public_path}/#{@song.song_binary.original_filename}"
  	# 
  	
  	path_to_store_file_to = "#{Rails.public_path}/tmpmusic/#{@song.id}"
  	Dir.mkdir path_to_store_file_to unless Dir.exists? path_to_store_file_to
  	
  	open("#{path_to_store_file_to}/#{@song.song_binary.original_filename}", 'wb') do |file|
     	AWS::S3::S3Object.stream(@song.song_binary.path,"binary_songs") do |chunk|
       		file.write chunk
     	end
   	end
  	
  	#TODO: consider :type=>audio/mpeg
  	# send_file "#{Rails.public_path}/songs/song_binaries/2/1-Bloom.mp3", :type=>"audio/mp3",:disposition => 'inline'
  	
  	send_file "#{path_to_store_file_to}/#{@song.song_binary.original_filename}", :type=>"audio/mpeg",:disposition => 'inline'

  	
  	# respond_to do |format|
  	#     	format.html { render :text=>"sampletest" }
  	# end

  end
end
