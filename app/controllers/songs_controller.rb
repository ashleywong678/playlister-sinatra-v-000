require "rack-flash"
  class SongsController < ApplicationController
  use Rack::Flash

  configure do
    enable :sessions
  end

  get '/songs/new' do
    erb :'/songs/new'
  end

  get '/songs' do
    @songs = Song.all
    erb :'songs/index'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params["slug"])
    erb :'/songs/show'
  end

  post '/songs' do
    @song = Song.find_or_create_by(:name => params["Name"])
    @song.artist = Artist.find_or_create_by(:name => params["Artist Name"])
    @song.genre_ids = params["genres"]
    @song.save
    flash[:message] = "Successfully created song."
    redirect "/songs/#{@song.slug}"
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params["slug"])
    erb :'/songs/edit'
  end

  patch '/songs/:slug' do
    @song = Song.find_by_slug(params["slug"])
    @song.update(:name => params["Name"], :artists => params["Artist Name"])
    if !params["genres"].empty?
      @song.genre_ids = Genre.create(params["genres"])
    else
      @song.genre_ids = params("genre")
    end
    @song.save
    redirect "songs/#{@song.slug}"
  end

end
