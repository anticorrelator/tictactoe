require 'set'

class ComputerPlayer < Player

  attr_accessor :marked_squares

  def initialize(player_id)
    @marked_squares = Set.new()
    @computer_player_id = player_id
    @best_first_moves = [1, 3, 7, 9]
  end

  def marks_best_square(current_game)
    move = pick_best_move(current_game)
    puts "The computer marks square #{move}."
    marks_square(move, current_game.available_squares)
  end

  def pick_best_move(current_game)
    return @best_first_moves.sample if current_game.new_game?

    best_node_score = -9999
    best_moves = []
    current_game.available_squares.each do |test_move|
      node_score = recursive_node_score(current_game.try(test_move), 0)
      case
      when node_score == best_node_score
        best_moves << test_move
      when node_score > best_node_score
        best_moves = [test_move]
        best_node_score = node_score
      end
    end

    best_moves.sample
  end

  def recursive_node_score(current_game, turn_depth)
    return terminal_score(current_game, turn_depth) unless current_game.state == 'active'

    subnode_scores = []
    current_game.available_squares.each do |test_move|
      subnode_scores << recursive_node_score(current_game.try(test_move), turn_depth + 1)
    end

    cpu_is_optimizing_player = (current_game.current_player_id == @computer_player_id) ? true : false
    cpu_is_optimizing_player ? subnode_scores.max : subnode_scores.min
  end

  def terminal_score(current_game, turn_depth)
    cpu_is_player_x = (@computer_player_id == 'Player X') ? 1 : -1
    case current_game.state
    when 'Player X wins!'
      cpu_is_player_x * (100 - turn_depth)
    when 'Player O wins!'
      cpu_is_player_x * (100 - turn_depth) * -1
    when 'The game is a draw.'
      0
    end
  end
end