require 'set'

class Player

  ROW_WINS = [Set.new([1, 2, 3]), Set.new([4, 5, 6]), Set.new([7, 8, 9])]
  COL_WINS = [Set.new([1, 4, 7]), Set.new([2, 5, 8]), Set.new([3, 6, 9])]
  DIA_WINS = [Set.new([1, 5, 9]), Set.new([3, 5, 7])]

  attr_accessor :marked_squares

  def initialize
    @marked_squares = Set.new()
  end

  def marks_square(index, available_squares)
    target_square = available_squares.delete(index)
    @marked_squares << target_square if target_square
  end

  def wins?
    case
    when ROW_WINS.any? {|row| row.subset? @marked_squares} then true
    when COL_WINS.any? {|col| col.subset? @marked_squares} then true
    when DIA_WINS.any? {|dia| dia.subset? @marked_squares} then true
    else false
    end
  end
end