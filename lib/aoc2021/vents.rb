# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Calculates conditions of victory for given plays and boards
  class Vents
    def initialize(file)
      @board = []
      @lines = file.readlines(chomp: true).map { |line| line.split(/\D/).reject(&:empty?).map(&:to_i) }
      parse_horizontal { |line| line[1] == line[3] }
      parse_vertical { |line| line[0] == line[2] && line[1] != line[3] }
    end

    def line_loop(filter_criteria, &block)
      @lines.filter(&filter_criteria).each(&block)
    end

    def parse_horizontal(&filter_criteria)
      line_loop(filter_criteria) do |line|
        ([line[0], line[2]].min..[line[0], line[2]].max).each do |x_index|
          y_index = line[1]
          count_vent x_index, y_index
        end
      end
    end

    def parse_vertical(&filter_criteria)
      line_loop(filter_criteria) do |line|
        ([line[1], line[3]].min..[line[1], line[3]].max).each do |y_index|
          x_index = line[0]
          count_vent x_index, y_index
        end
      end
    end

    def parse_diagonal(&filter_criteria)
      line_loop(filter_criteria) do |line|
        offset, slope = offset_and_slope(line)
        ([line[0], line[2]].min..[line[0], line[2]].max).each_with_index do |x_index, idx|
          y_index = offset + (slope * idx)
          count_vent x_index, y_index
        end
      end
    end

    def overlaps
      @board.flatten.filter { |val| val }.count { |int| int > 1 }
    end

    def overlaps_with_diagonals
      parse_diagonal { |line| line[0] != line[2] && line[1] != line[3] }
      overlaps
    end

    private

    def count_vent(x_index, y_index)
      @board[y_index]          = [] unless @board[y_index]
      @board[y_index][x_index] = 1 + (@board[y_index][x_index] || 0)
    end

    def offset_and_slope(line)
      if line[0] < line[2]
        [line[1], line[1] < line[3] ? 1 : -1]
      else
        [line[3], line[3] < line[1] ? 1 : -1]
      end
    end
  end
end
