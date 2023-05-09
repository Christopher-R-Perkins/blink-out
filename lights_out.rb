require "sinatra"
require "tilt/erubis"

require_relative 'libs/games/lights_out_board'

LIGHTSOUT = Games::LightsOutBoard

configure do
  enable :sessions
end

configure(:development) do
  require "sinatra/reloader"
  also_reload "libs/games/lights_out_board.rb"
end

helpers do
  def on_class(light)
    "on" if light
  end

  def path
    request.path_info
  end
end

before do
  @board = session[:lights_out]
end

get '/' do
  redirect '/game'
end

get '/game' do
  redirect "/game/#{LIGHTSOUT.random_seed}" unless @board && !@board.win?
  erb :board
end

post '/game' do
  @board.move! params['move'].to_i
  redirect '/game/win' if @board.win?
  redirect '/game'
end

get '/game/win' do
  redirect '/game' unless @board&.win?
  erb :win
end

get '/game/000000000000' do
  redirect '/game/3f3f3f3f3f3f'
end

get '/game/:seed' do
  seed = params[:seed]
  redirect "/game/#{LIGHTSOUT.random_seed}" unless LIGHTSOUT.valid_seed? seed

  @board = LIGHTSOUT.new seed
  erb :board
end

post '/game/:seed' do
  seed = params[:seed]
  @board = LIGHTSOUT.new seed
  session[:lights_out] = @board

  @board.move! params['move'].to_i
  redirect '/game'
end
