ENV["RACK_ENV"] = 'test'

require 'minitest/autorun'
require 'rack/test'
require 'uri'

require_relative '../lights_out'

class LightsOutTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def redirect_path
    URI.parse(last_response['Location']).path
  end

  def board_session(seed)
    { "rack.session" => { lights_out: LIGHTSOUT.new(seed) } }
  end

  def setup
    connection = PG.connect dbname: 'blink_out'
    connection.exec <<~SQL
      CREATE TABLE testscores (
        seed char(12) NOT NULL UNIQUE CHECK (seed ~ '^[0-9a-f]{12}$'),
        score integer NOT NULL CHECK (score > 0)
      );
    SQL
    connection.close
  end

  def teardown
    connection = PG.connect dbname: 'blink_out'
    connection.exec "DROP TABLE testscores;"
    connection.close
  end

  def test_index_redirect
    get '/'
    assert_equal 302, last_response.status
    assert_equal '/game', redirect_path
  end

  def test_game_redirect
    srand 12345
    get '/game'
    assert_equal 302, last_response.status
    assert_equal '/game/221d01221d01', redirect_path
  end

  def test_game_view
    get '/game', {}, board_session('3f3f3f3f3f3f')
    assert_equal 200, last_response.status
    lights_on = last_response.body.scan('class="on"').size
    assert_equal 36, lights_on
  end

  def test_game_win
    session = board_session('000000103810')
    post '/game', { move: '28' }, session

    assert_equal 302, last_response.status
    get last_response['Location'], {}, session
    assert_includes last_response.body, 'class="win"'
  end
end
