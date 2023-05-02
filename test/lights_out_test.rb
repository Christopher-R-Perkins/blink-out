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
    { "rack.session" => { lights_out: LIGHTSOUT.new(seed) }}
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
    assert_equal '/game/25t14', redirect_path
  end

  def test_game_view
    get 'game', {}, board_session('fight')
    assert_equal 200, last_response.status
    lights_on = last_response.body.scan('class="on"').size
    assert_equal 13, lights_on
  end
end
