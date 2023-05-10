ENV["RACK_ENV"] = 'test'

require 'minitest/autorun'

require_relative '../libs/database/highscore_connector'
require 'pg'

class HighscoreConnectorTest < Minitest::Test
  def setup
    connection = PG.connect dbname: 'blink_out'
    connection.exec <<~SQL
      CREATE TABLE testscores (
        seed char(12) NOT NULL UNIQUE CHECK (seed ~ '^[0-9a-f]{12}$'),
        score integer NOT NULL CHECK (score > 0)
      );
      INSERT INTO testscores (seed, score)
      VALUES ('0123456789ab', 27),
             ('ffffffffffff', 102);
    SQL
    connection.close
    @storage = Database::HighscoreConnector.new nil
  end

  def teardown
    @storage.disconnect
    connection = PG.connect dbname: 'blink_out', user: 'postgres', password: '!Redrum23'
    connection.exec "DROP TABLE testscores;"
    connection.close
  end

  def test_get_score
    score = @storage.get_score '0123456789ab'
    assert_equal 27, score
  end

  def test_update_score_old_seed
    @storage.update_score 'ffffffffffff', 32
    score = @storage.get_score 'ffffffffffff'
    assert_equal 32, score
  end

  def test_update_score_new_seed
    @storage.update_score 'cccccccccccc', 195
    score = @storage.get_score 'cccccccccccc'
    assert_equal 195, score
  end
end
