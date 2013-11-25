class Tile
  attr_accessor :relatives, :bomb, :display_value

  def self.get_random_tile
    is_bomb = rand < 0.2

    Tile.new(is_bomb)
  end

  def initialize(bomb)
    @flag = false
    @evaluated = false
    @relatives = []
    @display_value = "*"
    @bomb = bomb
  end

  def method
    self.bomb = 3
  end

  def bomb_count
    @bomb_count ||= calc_nearby_bombs
  end

  def calc_nearby_bombs
    bomb_count = 0

    relatives.each do |relative|
      bomb_count += 1 if relative.bomb
    end

    bomb_count
  end

  def to_s
    if @bomb
      "B"
    else
      @display_value
    end
  end

  def evaluate
    @display_value = bomb_count.to_s if bomb_count > 0
    @display_value = "_" if bomb_count == 0
    @display_value = "B" if @bomb
    @evaluated = true

    puts "finished evaluating"

    if @display_value == "_"
      puts "displaying a free node"
      nodes_to_eval = @relatives.select do |relative|
        !relative.flagged? && !relative.evaluated?
      end
      nodes_to_eval.each(&:evaluate)
    end
  end

  def flag
    @display_value = "F"
    @flag = true
  end

  def unflag
    @display_value = "*"
    @flag = false
  end

  def bomb?
    @bomb
  end

  def flagged?
    @flag
  end

  def evaluated?
    @evaluated
  end
end




