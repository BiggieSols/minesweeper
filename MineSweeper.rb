require_relative 'Board.rb'
require_relative 'Tile.rb'

class MineSweeper
  def initialize
    @board = Board.new
  end

  def get_move_coords
    puts "Input move in this format: x,y"
    next_move = gets.chomp.split(/,\s*/).map(&:to_i)
  end

  def get_move_type
    puts "would you like to
    1. check this node
    2. flag/un-flag
    "

    move_type = gets.chomp.to_i
  end

  def evaluate_move(move_coordinates, move_type)
    node = @board[*move_coordinates]

    if node.evaluated?
      puts "not a legal node!"
      return
    end

    case move_type
    when 1

      if node.flagged?
        puts "you must un-flag first"
        return
      else
        node.evaluate
      end

    when 2
      node.flagged? ? node.unflag : node.flag
    end

  end

  def run
    until @board.won? || @board.lost?
      print @board.inspect
      move_coords = get_move_coords

      move_type = get_move_type
      evaluate_move(move_coords, move_type)
    end

    print @board.inspect

    puts @board.won? ? "you win!" : "you got blown up, son!"
  end
end

game = MineSweeper.new.run