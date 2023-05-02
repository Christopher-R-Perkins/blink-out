require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

require_relative 'libs/games/lights_out_board'

configure do
  enable :sessions
end

helpers do
  def on?(light)
    "on" if light
  end

  def path
    request.path_info
  end
end

get '/game' do
  @board = session[:lights_out]

  erb :board
end

post '/game' do
  @board = session[:lights_out]
  @board.move! params['move'].to_i

  redirect '/game'
end

get '/game/:seed' do
  seed = params[:seed]

  @board = Games::LightsOutBoard.new seed
  erb :board
end

post '/game/:seed' do
  seed = params[:seed]
  @board = Games::LightsOutBoard.new seed
  session[:lights_out] = @board

  @board.move! params['move'].to_i
  redirect '/game'
end
