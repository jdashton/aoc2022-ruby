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
    @cells[idx] = nil if idx
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
    @boards = []
    read_boards(file)
  end

  def read_boards(file)
    # Discard an empty line
    lines = (0..5).map { |_| file.readline }
    @boards << Board.new(lines[1..5].reduce([]) { |acc, line| acc + line.split.map(&:to_i) })
    read_boards(file) unless file.eof?
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
      @plays       = Plays.new(file)
      @boards      = BoardsArray.new(file)
      @last_board  = nil
      @last_number = nil
    end

    def play_loop
      @plays.each do |number|
        play_each_board number
        yield
      end
    end

    def victory
      play_loop do
        winning_boards = @boards.filter(&:win?)
        unless winning_boards.empty?
          @last_board = winning_boards.first
          break
        end
      end
      score
    end

    def last_win
      play_loop do
        losing_boards = @boards.reject(&:win?)
        break if losing_boards.empty?

        @last_board = losing_boards.first if losing_boards.length <= 1
      end
      score
    end

    private

    def play_each_board(number)
      @boards.each { |board| board.play @last_number = number }
    end

    def score
      @last_board.reduce(0) { |acc, int| acc + (int || 0) } * @last_number
    end
  end
end
