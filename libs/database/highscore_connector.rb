require 'pg'

module Database
  class HighscoreConnector
    def initialize(logger)
      @db = if Sinatra::Base.production?
              PG.connect(ENV['DATABASE_URL'])
            else
              PG.connect dbname: "blink_out"
            end
      @table = Sinatra::Base.test? ? 'testscores' : 'highscores'
      @logger = logger
    end

    def get_score(seed)
      sql = "SELECT * FROM #{@table} WHERE seed = $1;"
      result = query sql, seed.downcase
      return nil if result.ntuples.zero?
      result.first['score'].to_i
    end

    def update_score(seed, score)
      value = get_score seed
      if value.nil?
        new_seed seed, score
      elsif value.to_i > score
        change_seed_score seed, score
      end
    end

    def query(statement, *params)
      @logger.info "#{statement}: #{params}"
      @db.exec_params statement, params
    end

    def disconnect
      @db.close
    end

    private
    def new_seed(seed, score)
      sql = <<~SQL
        INSERT INTO #{@table} (seed, score)
        VALUES ($1, $2)
      SQL
      query sql, seed.downcase, score
    end

    def change_seed_score(seed, score)
      sql = <<~SQL
        UPDATE #{@table}
           SET score = $2
         WHERE seed = $1;
      SQL
      query sql, seed.downcase, score
    end
  end
end
