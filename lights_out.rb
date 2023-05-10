require "sinatra"
require "tilt/erubis"

require_relative 'libs/games/lights_out_board'
require_relative 'libs/database/highscore_connector'

GAME = Games::LightsOutBoard

configure do
  enable :sessions
end

configure(:development) do
  require "sinatra/reloader"
  also_reload "libs/games/lights_out_board.rb"
  also_reload 'libs/database/highscore_connector.rb'
end

helpers do
  def on_class(light)
    "on" if light
  end

  def path
    request.path_info
  end

  def highscore(seed)
    @storage.get_score seed
  end
end

before do
  @board = session[:lights_out]
  @storage = Database::HighscoreConnector.new logger
end

after do
  @storage.disconnect
end

get '/' do
  redirect '/blinkout'
end

get '/blinkout' do
  redirect "/blinkout/#{GAME.random_seed}" unless @board && !@board.win?
  erb :board
end

post '/blinkout' do
  @board.move! params['move'].to_i
  check_for_win
  redirect '/blinkout'
end

get '/blinkout/win' do
  redirect '/blinkout' unless @board&.win?
  erb :win
end

get '/blinkout/000000000000' do
  redirect '/blinkout/3f3f3f3f3f3f'
end

get '/blinkout/:seed' do
  seed = params[:seed]
  redirect "/blinkout/#{GAME.random_seed}" unless GAME.valid_seed? seed

  @board = GAME.new seed
  erb :board
end

post '/blinkout/:seed' do
  seed = params[:seed]
  @board = GAME.new seed
  session[:lights_out] = @board

  @board.move! params['move'].to_i
  check_for_win
  redirect '/blinkout'
end

def check_for_win
  return unless @board&.win?
  @storage.update_score @board.initial_seed, @board.moves
  redirect '/blinkout/win'
end
