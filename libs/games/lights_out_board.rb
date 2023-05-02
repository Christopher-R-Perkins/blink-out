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
  end
end
