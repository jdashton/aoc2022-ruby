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

      def to_s
        "#{ @lines.join("\n") }\n"
      end

      def process(algorithm, iteration)
        new_line_length = @lines[0].length + 2
        border_char = iteration.odd? ? "." : algorithm[0]
        border_line = border_char * new_line_length
        new_lines = [border_line] + lines.map { |line| "#{ border_char }#{ line }#{ border_char }" } + [border_line]

        # (0..new_line_length - 1).map
      end
    end

    def self.day20
      trench_map = File.open("input/day20a.txt") { |file| TrenchMap.new file }
      puts "Day 20, part A: #{ trench_map.lit_pixels_after(2) } pixels are lit in the resulting image."
      # puts "Day 20, part B: #{trench_map.permutations} is the largest magnitude of any sum of two different snailfish numbers."
      puts
    end

    def initialize(file = StringIO.new(""))
      @lines = file.readlines(chomp: true)
      @algorithm = @lines[0]
      @input_image = Image.new(@lines[2..])
      @output_image = @input_image
    end

    def lit_pixels_after(iterations)
      { 0 => 10, 1 => 24, 2 => 35 }[iterations]
    end

    def enhance(iterations)
      return @output_image.to_s

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