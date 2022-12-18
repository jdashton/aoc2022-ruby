# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 9, we're move the rope's tail.
    class RopeBridge
      def self.day09
        File.open('input/day09.txt') do |file|
          puts "Day  9, Part One: The tail of the rope visits #{ RopeBridge.new(file).short_positions } positions at least once."
          file.rewind
          puts "Day  9, Part Two: The tail of the rope visits #{ RopeBridge.new(file).long_positions } positions at least once."
        end
        puts
      end

      START = [0, 0].freeze

      def initialize(file)
        @lines   = file.readlines(chomp: true).map(&:split)
        @visited = Set[START.map(&:to_s).join(',')]
        @knots   = Array.new(10) { Array.new(START) }
      end

      DIRECTION =
        {
          'R' => [+1, 0],
          'L' => [-1, 0],
          'U' => [0, -1],
          'D' => [0, +1]
        }.freeze

      def move(direction, distance, knots)
        distance.to_i.times do
          @knots[0] = @knots.first.zip(DIRECTION[direction]).map(&:sum)
          knots.each_cons(2) { |a, b| @knots[b] = RopeBridge.move_tail(@knots[a], @knots[b]) }
          @visited << @knots[knots.last].join(',')
        end
      end

      def self.move_tail((head_x, head_y), (tail_x, tail_y))
        unless (head_x - tail_x).abs <= 1 && (head_y - tail_y).abs <= 1
          tail_x += head_x > tail_x ? +1 : -1 unless head_x == tail_x
          tail_y += head_y > tail_y ? +1 : -1 unless head_y == tail_y
        end
        [tail_x, tail_y]
      end

      def short_positions
        @lines.each { |line| move(*line, (0..1)) }
        @visited.size
      end

      def long_positions
        @lines.each { |line| move(*line, (0..9)) }
        @visited.size
      end
    end
  end
end
