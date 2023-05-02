require 'minitest/autorun'

require_relative '../libs/games/lights_out_board'

class LightsOutBoardTest < Minitest::Test
  def test_valid_seed?
    assert Games::LightsOutBoard.valid_seed?('0u3dj')
    refute Games::LightsOutBoard.valid_seed?('pkmzd')
    refute Games::LightsOutBoard.valid_seed?('000000')
  end

  def test_to_s
    lights = Games::LightsOutBoard.new '0u3dj'
    assert_equal '0u3dj', lights.to_s
  end

  def test_initialize_error
    assert_raises(ArgumentError) { Games::LightsOutBoard.new '012345' }
  end

  def test_move
    board = Games::LightsOutBoard.new 'oi720'
    board.move! 0
    assert_equal '02720', board.to_s
    board.move! 13
    assert_equal '00000', board.to_s
  end

  def test_move_error
    board = Games::LightsOutBoard.new 'uuuuu'
    assert_raises(IndexError) { board.move!(-1) }
    assert_raises(IndexError) { board.move!(25) }
  end

  def test_initial_seed
    board = Games::LightsOutBoard.new 'fight'
    assert_equal 'fight', board.initial_seed
  end
end
