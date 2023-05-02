module Games
  class LightsOutBoard
    CHARACTER_VALUES = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
                        'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
                        'u']

    def self.valid_seed?(seed)
      return false unless seed.size == 5;
      return false unless seed.chars.all? { |ch| CHARACTER_VALUES.include? ch }
      true
    end

    def initialize(seed)
      unless LightsOutBoard.valid_seed? seed
        raise ArgumentError.new "Invalid Seed"
      end
      @seed = seed
      @lights = from_seed seed
    end

    def to_s
      to_seed
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

      until value == 0
        value, remainder = value.divmod 2
        row.unshift(remainder == 1)
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
  end
end
