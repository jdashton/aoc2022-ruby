# frozen_string_literal: true

require 'forwardable'

module AoC2022
  module Puzzles
    # For Day 17, we're playing Tetris.
    class PyroclasticFlow
      def self.day17
        pyroclastic_flow = File.open('input/day17.txt') { |file| PyroclasticFlow.new file }
        puts "Day 17, Part One: #{ pyroclastic_flow.drop_rocks } is the height after 2022 rocks."
        # puts "Day 17, Part Two: #{ pyroclastic_flow.tuning_frequency(4_000_000) } is the tuning frequency."
        puts
      end

      def initialize(file)
        @chamber      = [Array.new(7), Array.new(7), Array.new(7)]
        @gusts        = file.readlines(chomp: true).first.chars
        @falling_rock = nil
      end

      ROCK_TYPES = %w[#### .#.\n###\n.#. ..#\n..#\n### #\n#\n#\n# ##\n##].freeze

      def render
        (0..(@chamber.length - 1)).to_a.reverse.each do |i|
          puts "|#{ @chamber[i].map { _1 || '.' }.join }|"
        end
        puts "+-------+\n\n"
      end

      def add_rock(rock)
        @chamber.push(Array.new(7)) until @chamber.last(3).all? { _1.all?(&:nil?) }
        @chamber.push([nil, nil, *rock.tr('#', '@').chars, nil])
      end

      def drop_rocks
        add_rock(ROCK_TYPES.first)
        render
        3068
      end
    end
  end
end
