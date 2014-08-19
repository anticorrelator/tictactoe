require 'set'

class Game

  attr_accessor :state, :available_squares, :current_player, :player_x, :player_o

  def initialize
    @player_x = Player.new
    @player_o = Player.new

    @available_squares = (1..9).to_a
    @board = {}
    @available_squares.each { |index| @board[index] = index }
    @state = 'active'
    @current_player = @player_x
  end

  def play
    vs_computer ? play_with_computer : play_with_human

    draw_board
    puts @state
  end

  def play_with_human
    while @state == 'active'
      draw_board
      current_player_turn_alert

      input = pick_move_prompt
      @current_player.marks_square(input, @available_squares)
      update_game_state
      switch_current_player
    end
  end

  def play_with_computer
    if go_first?
      @player_o = ComputerPlayer.new('Player O')
    else
      @player_x = @current_player = ComputerPlayer.new('Player X')
    end

    while @state == 'active'
      if @current_player.is_a? ComputerPlayer
        @current_player.marks_best_square(self)
        update_game_state
        switch_current_player
      else
        draw_board
        puts "It's your turn."

        input = pick_move_prompt
        @current_player.marks_square(input, @available_squares)
        update_game_state
        switch_current_player
      end
    end
  end

  def prompt(string)
    print(string + "\n>> ")
    gets.strip
  end

  def protected_prompt(string, acceptable_answers, error_string)
    input = nil
    until acceptable_answers.include? input
      input = prompt(string)
      unless acceptable_answers.include? input
        puts error_string
      end
    end
    input
  end

  def vs_computer
    input = protected_prompt('Would you like to play against a computer? (y/n)',
                             ['y', 'n'],
                             'Please select a valid answer. Try again')

    input == 'y' ? true : false
  end

  def go_first?
    input = protected_prompt('Would you like to go first? (y/n)',
                             ['y', 'n'],
                             'Please select a valid answer. Try again')

    input == 'y' ? true : false
  end

  def pick_move_prompt
    input = protected_prompt("Make a move by selecting a numbered square!",
                             @available_squares.map { |i| i.to_s },
                             "You can only mark an available square. Try again.")
    input.to_i
  end

  def update_game_state
    @player_x.marked_squares.each { |index| @board[index] = 'X' }
    @player_o.marked_squares.each { |index| @board[index] = 'O' }
    case
    when @player_x.wins? then @state = 'Player X wins!'
    when @player_o.wins? then @state = 'Player O wins!'
    when @available_squares.empty? then @state = 'The game is a draw.'
    end
  end

  def try(move)
    spawn = Game.new
    spawn.current_player = (@current_player == @player_x) ? spawn.player_x : spawn.player_o
    spawn.available_squares = @available_squares.clone
    spawn.player_x.marked_squares = @player_x.marked_squares.clone
    spawn.player_o.marked_squares = @player_o.marked_squares.clone
    spawn.current_player.marks_square(move, spawn.available_squares)
    spawn.update_game_state
    spawn.switch_current_player
    spawn
  end

  def current_player_id
    (@current_player == @player_x) ? ("Player X") : ("Player O")
  end

  def current_player_turn_alert
    puts(current_player_id + "'s turn.")
  end

  def switch_current_player
    @current_player = (@current_player == @player_x) ? @player_o : @player_x
  end

  def new_game?
    return true if @available_squares.count == 9
    false
  end

  def draw_board
    puts "
    | #{@board[1]} | #{@board[2]} | #{@board[3]} |\n
    | #{@board[4]} | #{@board[5]} | #{@board[6]} |\n
    | #{@board[7]} | #{@board[8]} | #{@board[9]} |\n
    "
  end
end