require 'minitest/autorun'

require_relative '../libs/games/lights_out_board'

class LightsOutBoardTest < Minitest::Test
  def test_valid_seed?
    assert Games::LightsOutBoard.valid_seed?('0f3a2b08101c')
    refute Games::LightsOutBoard.valid_seed?('lol')
    refute Games::LightsOutBoard.valid_seed?('0000000000000')
    refute Games::LightsOutBoard.valid_seed?('403a2b08101c')
  end

  def test_to_s
    lights = Games::LightsOutBoard.new '0f3a2b08101c'
    assert_equal '0f3a2b08101c', lights.to_s
  end

  def test_initialize_error
    assert_raises(ArgumentError) { Games::LightsOutBoard.new '012345' }
  end

  def test_move
    board = Games::LightsOutBoard.new '030100103810'
    board.move! 0
    assert_equal '000000103810', board.to_s
    board.move! 28
    assert_equal '000000000000', board.to_s
  end

  def test_move_error
    board = Games::LightsOutBoard.new '3f3f3f3f3f3f'
    assert_raises(IndexError) { board.move!(-1) }
    assert_raises(IndexError) { board.move!(36) }
  end

  def test_initial_seed
    board = Games::LightsOutBoard.new '0f3a2b08101c'
    assert_equal '0f3a2b08101c', board.initial_seed
  end

  def test_random_seed
    10.times do
      seed = Games::LightsOutBoard.random_seed
      assert Games::LightsOutBoard.valid_seed?(seed)
    end
  end

  def test_win
    board = Games::LightsOutBoard.new '000000000000'
    assert_equal true, board.win?
    board.move! 0
    assert_equal false, board.win?
  end
end
