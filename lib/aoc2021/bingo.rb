# frozen_string_literal: true

require "forwardable"

# Describes the cells in a single Bingo board.
class Board
  extend Forwardable
  def_instance_delegators :@cells, :reduce

  def initialize(cells)
    @cells = cells
  end

  def play(number)
    idx         = @cells.index(number)
    @cells[idx] = nil unless idx.nil?
  end

  def win?
    @cells.each_slice(5) { |ary| return true if ary.all?(&:nil?) }
    (0..4).each { |idx| return true if @cells[(idx..).step(5)].all?(&:nil?) }
    false
  end
end

# Holds a list of the Bingo boards we're considering.
class BoardsArray
  extend Forwardable
  def_instance_delegators :@boards, :[], :each, :any?, :filter, :reject

  def initialize(file)
    @boards = read_boards(file, [])
  end

  def read_boards(file, boards)
    return boards if file.eof?

    # Expect an empty line
    file.readline
    boards << Board.new((0..4).reduce([]) { |acc, _| acc + file.readline.split.map(&:to_i) })
    read_boards(file, boards)
  end
end

# Holds a list of each number that will be "called" in this game.
class Plays
  extend Forwardable
  def_instance_delegators :@plays, :[], :each

  def initialize(file)
    @plays = file.readline.split(",").map(&:to_i)
  end
end

module AoC2021
  # Calculates conditions of victory for given plays and boards
  class Bingo
    def initialize(file)
      @plays  = Plays.new(file)
      @boards = BoardsArray.new(file)
    end

    def victory
      winning_boards = []
      last_number    = 0
      @plays.each do |number|
        last_number = number
        @boards.each { |board| board.play number }
        winning_boards = @boards.filter(&:win?)
        break unless winning_boards.empty?
      end
      score winning_boards.first, last_number
    end

    def last_win
      last_board = last_number = nil
      @plays.each do |number|
        last_number = number
        @boards.each { |board| board.play number }
        losing_boards = @boards.reject(&:win?)
        last_board    = losing_boards.first if losing_boards.length == 1
        break if losing_boards.empty?
      end
      score last_board, last_number
    end

    private

    def score(board, last_number)
      board.reduce(0) { |acc, int| acc + (int || 0) } * last_number
    end
  end
end
