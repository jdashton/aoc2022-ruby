# frozen_string_literal: true

require "forwardable"

# Point class to handle X and y coordinates
class Point
  attr_reader :x, :y

  # noinspection RubyInstanceVariableNamingConvention
  def initialize(x, y)
    @x = x
    @y = y
  end

  def offset_and_slope(other)
    other_y = other.y
    if @x < other.x
      [@y, @y < other_y ? 1 : -1]
    else
      [other_y, other_y < @y ? 1 : -1]
    end
  end
end

module AoC2021
  # Calculates conditions of victory for given plays and boards
  class Vents
    def initialize(file)
      @board = []
      @lines = file.readlines(chomp: true).map { |line| line.split(/\D/).reject(&:empty?).map(&:to_i) }
      parse_horizontal { |_, y_one, _, y_two| y_one == y_two }
      parse_vertical { |x_one, y_one, x_two, y_two| x_one == x_two && y_one != y_two }
    end

    def line_loop(filter_criteria, &block)
      @lines.filter(&filter_criteria).each(&block)
    end

    def parse_horizontal(&filter_criteria)
      line_loop(filter_criteria) do |x_one, y_index, x_two, _|
        ([x_one, x_two].min..[x_one, x_two].max).each do |x_index|
          count_vent x_index, y_index
        end
      end
    end

    def parse_vertical(&filter_criteria)
      line_loop(filter_criteria) do |x_index, y_one, _, y_two|
        ([y_one, y_two].min..[y_one, y_two].max).each do |y_index|
          count_vent x_index, y_index
        end
      end
    end

    def parse_diagonal(&filter_criteria)
      line_loop(filter_criteria) do |x_one, y_one, x_two, y_two|
        offset, slope = Point.new(x_one, y_one).offset_and_slope(Point.new(x_two, y_two))
        ([x_one, x_two].min..[x_one, x_two].max).each_with_index do |x_index, idx|
          count_vent x_index, offset + (slope * idx)
        end
      end
    end

    def overlaps
      @board.flatten.filter { |val| val }.count { |int| int > 1 }
    end

    def overlaps_with_diagonals
      parse_diagonal { |x_one, y_one, x_two, y_two| x_one != x_two && y_one != y_two }
      overlaps
    end

    private

    def count_vent(x_index, y_index)
      row             = @board[y_index] || []
      row[x_index]    = (row[x_index] || 0) + 1
      @board[y_index] = row
    end
  end
end
