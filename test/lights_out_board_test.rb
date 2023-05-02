require 'minitest/autorun'

require_relative '../libs/games/lights_out_board'

class LightsOutBoardTest < Minitest::Test
  def test_valid_seed?
    assert Games::LightsOutBoard.valid_seed?('0u3dj')
    refute Games::LightsOutBoard.valid_seed?('pkmzd')
    refute Games::LightsOutBoard.valid_seed?('000000')
  end
end
