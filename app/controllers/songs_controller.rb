require 'rack-flash'

class SongsController < ApplicationController

  enable :sessions
  use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

  get '/songs/new' do
    erb :'/songs/new'
  end

  post '/songs/new' do
    song = Song.create(name: params[:name])
    song.artist = Artist.find_or_create_by(name: params[:artist_name])

    params[:genres].each do |genre_id|
      song.genres.push(Genre.find(genre_id))
    end
    song.save
    flash[:message] = "Successfully created song."
    redirect "/songs/#{song.slug}"
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'/songs/show'
  end

  patch '/songs/:slug' do
    song = Song.find_by_slug(params[:slug])
    song.name = params[:name]
    song.artist = Artist.find_or_create_by(name: params[:artist_name])
    song.genres.clear
    params[:genres].each do |genre_id|
      song.genres.push(Genre.find(genre_id))
    end
    song.save
    flash[:message] = "Successfully updated song."
    redirect "/songs/#{song.slug}"
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    erb :'/songs/edit'
  end

end
