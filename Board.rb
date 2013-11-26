class Board
  def initialize
    @board_grid = Array.new(9) { Array.new(9) { Tile.get_random_tile } }
    build_tile_graph
  end

  def inspect
    str = "      [0][1][2][3][4][5][6][7][8]\n"
    @board_grid.each_index do |row|
      str += "\n[#{row}]   "
      @board_grid[row].each_index do |column|
        str += "[#{@board_grid[row][column].to_s}]"
      end
    end
    str += "\n"
  end

  def build_tile_graph
    9.times do |row|
      9.times do |col|
        neighboring_coords = get_neighboring_coords( [row, col] )
        current_node = @board_grid[row][col]
        neighboring_coords.each do |coord|
          current_node.relatives << @board_grid[ coord[0] ][ coord[1] ]
        end
      end
    end
  end

  def get_neighboring_coords(coord)
    offsets = []

    x, y = coord
    offset_points = [-1, 0, 1]

    offset_points.each do |row_offset|
      offset_points.each do |col_offset|
        new_x = x + row_offset
        new_y = y + col_offset

        next if row_offset == 0 && col_offset == 0
        # next if [new_x, new_y].any? { |coord| coord.between?(0, 8) }
        next if new_x < 0  || new_y < 0
        next if new_x > 8  || new_y > 8
        offsets << [new_x, new_y]
      end
    end
    offsets
  end

  def won?
    all_bombs_flagged = true
    all_nodes_guessed = true

    (0...9).each do |row_i|
      (0...9).each do |col_i|
        # puts "Evaluating #{row_i}, #{col_i}"
        node = @board_grid[row_i][col_i]

        if (!node.bomb? && node.flagged? || !node.bomb? && !node.evaluated?)
          all_nodes_guessed = false
        end

        if node.bomb? && !node.flagged?
          all_bombs_flagged = false
        end
      end
    end
    all_bombs_flagged || all_nodes_guessed
  end

  def lost?
    (0...9).each do |row_i|
      (0...9).each do |col_i|
        node = @board_grid[row_i][col_i]
        return true if node.bomb? && node.evaluated?
      end
    end
    false
  end

  def [](row, col)
    @board_grid[row][col]
  end
end
