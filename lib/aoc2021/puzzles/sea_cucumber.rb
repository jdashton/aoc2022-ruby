# frozen_string_literal: true

require "set"
require "forwardable"

module AoC2021
  # SeaCucumber implements the solutions for Day 8.
  class SeaCucumber
    def self.day25
      segments = File.open("input/day25a.txt") { |file| SeaCucumber.new file }
      puts "Day 25, part A: #{ segments.moves_to_final } is the first step in which no sea cucumbers move."
      puts
    end

    attr_reader :next

    def initialize(file)
      @lines = file.readlines(chomp: true).map(&:chars)
      # puts @lines.map(&:join).join "\n"
      # puts
      @previous = @next = []
      @current  = @lines
    end

    def finalize = @current = @next

    def moves_to_final
      moves = 0
      loop do
        one_step
        moves += 1
        return moves if @previous == @current
      end
    end

    def east_row(row_num)
      @next[row_num] = @current[row_num].each_with_index.map do |char, idx|
        case char
          when "v" then "v"
          when ">" then (@current[row_num][idx + 1] || @current[row_num][0]) == "." ? "." : ">"
          else @current[row_num][idx - 1] == ">" ? ">" : "."
        end
      end
    end

    def east_board
      @current.each_index do |row_num|
        @next[row_num] = []
        east_row(row_num)
      end
    end

    def south_col(col_num)
      # puts "Starting with \n#{ @current.map(&:join).join "\n" }"
      @current.each_index do |row_num|
        @next[row_num]          ||= []
        @next[row_num][col_num] = case @current[row_num][col_num]
                                    when ">" then ">"
                                    when "v" then (@current.dig(row_num + 1, col_num) || @current[0][col_num]) == "." ? "." : "v"
                                    else @current[row_num - 1][col_num] == "v" ? "v" : "."
                                  end
      end
      # puts "\nProduced \n#{ @next.map(&:join).join "\n" }"
    end

    def south_board
      (0...@current[0].length).each do |col_num|
        south_col(col_num)
      end
    end

    def one_step
      @previous = @current
      @next     = []
      east_board
      @current = @next
      @next    = []
      south_board
      @current = @next
    end

    def after_steps(num_steps)
      num_steps.times do ||
        one_step
      end
      (@current.map(&:join).join "\n") + "\n"
    end
  end
end
