class SongsController < ApplicationController
  def index
    @songs = Song.all.order(id: :desc)
  end

  def show
    @song = Song.find_by_id(params[:id])
    unless @song
      redirect_to '/'
    end
  end

  def addToList
    song = Song.find(params[:song].to_i)
    song.count += 1
    song.save
    playlist = Playlist.find_by(song_id:song.id, user_id:session[:id])
    if playlist
      playlist.count += 1
      playlist.save
    else
      Playlist.create(song_id:song.id, user_id:session[:id], count:1)
    end
    redirect_to "/songs/index"
  end

  def create
    if params[:title].length < 2 || params[:author].length < 2
      flash[:errors] = ["title and author names must be longer than 2 characters"]
    else
      Song.create(title:params[:title], author:params[:author], count:0)
    end
    redirect_to '/songs/index'
  end
end
