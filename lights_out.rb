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
end

get '/game/:seed' do
  seed = params[:seed]

  @board = Games::LightsOutBoard.new seed
  erb :board
end
