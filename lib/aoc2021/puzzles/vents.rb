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

  def same_x(other) = @x == other.x

  def same_y(other) = @y == other.y
end

# Line handles calculations for a start and end point
class Line
  def initialize(start_point, end_point)
    @start = start_point
    @end   = end_point
  end

  def horizontal? = @start.y == @end.y

  def vertical? = @start.x == @end.x

  def parse_horizontal(vents)
    Range.new(*[@start.x, @end.x].sort).each do |x_index|
      vents.count_vent x_index, @start.y
    end
  end

  def parse_vertical(vents)
    Range.new(*[@start.y, @end.y].sort).each do |y_index|
      vents.count_vent @start.x, y_index
    end
  end

  def parse_diagonal(vents)
    offset, slope = @start.offset_and_slope(@end)
    Range.new(*[@start.x, @end.x].sort).each_with_index do |x_index, idx|
      vents.count_vent x_index, offset + (slope * idx)
    end
  end
end

# VentLines manages a collection of lines of vents.
class VentLines
  extend Forwardable
  def_instance_delegators :@lines, :filter, :each

  def initialize(file)
    @lines             = file.readlines(chomp: true)
                             .map { |line| line.split(/\D/).reject(&:empty?).map(&:to_i) }
                             .map { |p1x, p1y, p2x, p2y| Line.new(Point.new(p1x, p1y), Point.new(p2x, p2y)) }
    @h_lines, other    = @lines.partition(&:horizontal?)
    @v_lines, @d_lines = other.partition(&:vertical?)
  end

  def horizontal_lines = @h_lines

  def vertical_lines = @v_lines

  def diagonal_lines = @d_lines
end

module AoC2021
  # Calculates conditions of victory for given plays and boards
  class Vents
    def self.day05
      vents = File.open("input/day05a.txt") { |file| Vents.new file }
      puts "Day  5, part A: #{ vents.overlaps } vents that are in two or more lines (horizontal or vertical)"
      puts "Day  5, part B: #{ vents.overlaps_with_diagonals } vents in any two or more lines (including diagonal)"
      puts
    end

    def initialize(file)
      @board = []
      @lines = VentLines.new(file)
      parse_horizontal
      parse_vertical
    end

    def line_loop(filter_criteria, &block)
      @lines.filter(&filter_criteria).each(&block)
    end

    def parse_horizontal
      @lines.horizontal_lines.each { |line| line.parse_horizontal self }
    end

    def parse_vertical
      @lines.vertical_lines.each { |line| line.parse_vertical self }
    end

    def parse_diagonal
      @lines.diagonal_lines.each { |line| line.parse_diagonal self }
    end

    def overlaps
      @board.flatten.filter { |val| val }.count { |int| int > 1 }
    end

    def overlaps_with_diagonals
      parse_diagonal
      overlaps
    end

    def count_vent(x_index, y_index)
      row             = @board[y_index] || []
      row[x_index]    = (row[x_index] || 0) + 1
      @board[y_index] = row
    end
  end
end
