module Games
  class LightsOutBoard
    CHARACTER_VALUES = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
                        'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
                        'u', 'v']

    def self.valid_seed?(seed)
      return false unless seed.size == 5
      return false unless seed.chars.all? { |ch| CHARACTER_VALUES.include? ch }
      true
    end

    def self.random_seed
      5.times.with_object([]) do |_, out|
        out << CHARACTER_VALUES.sample
      end.join
    end

    attr_reader :moves

    def initialize(seed)
      unless LightsOutBoard.valid_seed? seed
        raise ArgumentError, "Invalid Seed"
      end
      @seed = seed
      @lights = from_seed seed
      @moves = 0
    end

    def to_s
      to_seed
    end

    def each_with_index
      idx = 0
      @lights.each do |row|
        row.each do |light|
          yield light, idx
          idx += 1
        end
      end

      self
    end

    def initial_seed
      @seed
    end

    def move!(index)
      raise IndexError, 'Move index out of bounds' unless (0..24).cover? index
      row, col = index.divmod 5
      toggle_light row, col
      toggle_light row - 1, col
      toggle_light row + 1, col
      toggle_light row, col - 1
      toggle_light row, col + 1
      @moves += 1
    end

    private

    def from_seed(seed)
      seed.chars.each_with_object([]) do |character, board|
        value = CHARACTER_VALUES.index character
        board << lights_row(value)
      end
    end

    def lights_row(value)
      row = []

      5.times do
        value, remainder = value.divmod 2
        row = [remainder == 1] + row
      end

      row
    end

    def to_seed
      @lights.map do |row|
        value = 0
        row.reverse_each.with_index do |light, idx|
          value += 2**idx if light
        end

        CHARACTER_VALUES[value]
      end.join
    end

    def toggle_light(row, col)
      return unless (0..4).cover?(row) && (0..4).cover?(col)
      @lights[row][col] = !@lights[row][col]
    end
  end
end
