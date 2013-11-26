require_relative 'Board.rb'
require_relative 'Tile.rb'
require 'yaml'

class MineSweeper
  MOVES = [:check, :flag, :save, :exit]

  def initialize
  end

  def load_board
    return Board.new if Dir["./*.yml"].empty?

    puts "would you like to start a new game, or load from file?"
    puts "1. new game"
    puts "2. load from file"

    user_selection = gets.chomp.to_i

    return Board.new if user_selection == 1
    return load_correct_save if user_selection == 2

    puts "you must select 1 or 2!"
    start_game_options
  end

  def load_correct_save
    available_saved_games = get_available_saved_games

    available_saved_games.each_with_index do |save, i|
      puts "[#{i + 1}]: #{save}"
    end

    puts "Enter number of save"
    user_choice = gets.chomp.to_i

    YAML.load_file("#{available_saved_games[user_choice - 1]}.yml")
  end

  def get_available_saved_games
    available_files = Dir["./*.yml"]
    available_files.map! { |arr| arr[2..-5]}
  end

  def get_move_coords
    puts "Input move in this format: x,y"
    next_move = gets.chomp.split(/,\s*/).map(&:to_i)
  end


  def get_move_type


    puts "would you like to
    1. check a node
    2. flag/un-flag
    3. Save to file
    4. Exit the game
    "

    move_type = MOVES[gets.chomp.to_i-1]
  end

  def evaluate_move(move_coordinates, move_type)
    node = @board[*move_coordinates]

    if node.evaluated?
      puts "not a legal node!"
      return
    end

    case move_type
    when :check

      if node.flagged?
        puts "you must un-flag first"
        return
      else
        node.evaluate
      end

    when :flag
      node.flagged? ? node.unflag : node.flag
    end

  end

  def run
    @board = load_board

    until @board.won? || @board.lost?
      print @board.inspect

      move_type = get_move_type

      if move_type == :save
        save
      elsif move_type == :exit
        return
      elsif move_type == :flag || move_type == :check
        move_coords = get_move_coords
        evaluate_move(move_coords, move_type)
      end
    end

    print @board.inspect

    puts @board.won? ? "you win!" : "you got blown up, son!"
  end

  def save
    puts "here are the existing saved files"
    get_available_saved_games.each do |game|
      puts game
    end

    puts
    puts "enter the name of your saved game"
    name = gets.chomp

    File.open("#{name}.yml", 'w') do |f|
      f.write @board.to_yaml
    end
  end
end

game = MineSweeper.new.run