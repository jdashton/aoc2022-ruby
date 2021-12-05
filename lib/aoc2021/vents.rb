# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Calculates conditions of victory for given plays and boards
  class Vents
    def initialize(file)
      @board = []
      @lines = file.readlines(chomp: true).map { |line| line.split(/\D/).reject(&:empty?).map(&:to_i) }
      # @lines.each do |line|
      #   pp line
      # end
      parse_horizontal
      parse_vertical
      # pp @board
    end

    def parse_horizontal
      @lines.filter { |line| line[1] == line[3] }.each do |line|
        ([line[0], line[2]].min..[line[0], line[2]].max).each do |x_index|
          @board[line[1]]          = [] unless @board[line[1]]
          @board[line[1]][x_index] = 1 + (@board[line[1]][x_index] || 0)
        end
      end
    end

    def parse_vertical
      @lines.filter { |line| line[0] == line[2] }.each do |line|
        ([line[1], line[3]].min..[line[1], line[3]].max).each do |y_index|
          @board[y_index]          = [] unless @board[y_index]
          @board[y_index][line[0]] = 1 + (@board[y_index][line[0]] || 0)
        end
      end
    end

    def overlaps
      @board.flatten.filter { |val| val }.count { |int| int > 1 }
    end
  end
end
