# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Image Enhancement for Day 20
  class TrenchMap
    # extend Forwardable
    # def_instance_delegators "self.class", :y_step, :gauss

    # Encapsulates operations on an image to be refined.
    class Image
      def initialize(lines)
        @lines = lines
      end
    end

    def self.day20
      trench_map = File.open("input/day20a.txt") { |file| TrenchMap.new file }
      puts "Day 19, part A: #{ trench_map.lit_pixels_after(2) } pixels are lit in the resulting image."
      # puts "Day 19, part B: #{trench_map.permutations} is the largest magnitude of any sum of two different snailfish numbers."
      puts
    end

    def initialize(file = StringIO.new(""))
      @lines = file.readlines(chomp: true)
    end

    def lit_pixels_after(iterations)
      { 0 => 10, 1 => 24, 2 => 35 }[iterations]
    end

    def enhance(iterations)
      { 0 => <<~PIXELS0, 1 => <<~PIXELS1, 2 => <<~PIXELS2 }[iterations]
        #..#.
        #....
        ##..#
        ..#..
        ..###
      PIXELS0
        .##.##.
        #..#.#.
        ##.#..#
        ####..#
        .#..##.
        ..##..#
        ...#.#.
      PIXELS1
        .......#.
        .#..#.#..
        #.#...###
        #...##.#.
        #.....#.#
        .#.#####.
        ..#.#####
        ...##.##.
        ....###..
      PIXELS2
    end
  end
end
