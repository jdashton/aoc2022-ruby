# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 22, we're tracing a password.
    class MonkeyMap
      def self.day22
        monkey_map = File.open('input/day22.txt') { |file| MonkeyMap.new file }
        puts "Day 22, Part One: #{ monkey_map.part_one } is the final password."
        puts "Day 22, Part Two: #{ monkey_map.part_two } is the final password."
        puts
      end

      # :reek:FeatureEnvy
      def initialize(file)
        @board, @x_ranges, @y_ranges, @path = MonkeyMap.parse(file.readlines(chomp: true))

        @wrapping, @board_size = @board.size > 16 ? [WRAPPINGS_FIFTY, 50] : [WRAPPINGS_FOUR, 4]

        WRAPPINGS_FLAT.merge!(
          {
            east:  ->(y) { [@x_ranges[y].first, y, :east] },
            west:  ->(y) { [@x_ranges[y].last, y, :west] },
            north: ->(x) { [x, @y_ranges[x].last, :north] },
            south: ->(x) { [x, @y_ranges[x].first, :south] }
          }
        )
      end

      # WRAP_SIZE = {
      #   13 => [WRAPPINGS_FOUR, 4],
      #   201 => [WRAPPINGS_FIFTY, 50]
      # }.tap { |hash| hash.default_proc = proc { |_, key| pp "size not found: #{ key }." } }

      def self.parse(lines)
        x_ranges, y_ranges = [[], []]

        board = lines[...-2].map.with_index { |line, y|
          x = line =~ /[.#]/

          x_ranges[y] = (x_range = x...line.length).minmax
          x_range.each { |i| y_ranges[i] = ((y_ranges[i] || [y, y]) << y).minmax }
          Array.new(x) + line[x..].chars + [nil]
        } + [[]]
        [board, x_ranges, y_ranges, lines.last.split(/([LR])/).map { |op| (num = op.to_i).positive? ? num : op.to_sym }]
      end

      TRANSLATION_PROC = proc { |hash, key| hash[key[((key =~ /_/) + 1)..].to_sym] }
      WRAPPINGS_FLAT   = {}.tap { |hash| hash.default_proc = TRANSLATION_PROC }

      WRAPPINGS_FOUR = {
        y4_east:  ->(y) { [7 - y + 12, 8, :south] },
        x8_south: ->(x) { [11 - x, 7, :north] },
        x4_north: ->(x) { [8, x - 4, :east] }
      }.tap { |hash| hash.default_proc = proc { |_, key| pp "Please implement 4 wrapping for #{ key }." } }.freeze

      WRAPPINGS_FIFTY = {
        x0_north:   ->(x) { [50, x + 50, :east] },
        x0_south:   ->(x) { [x + 100, 0, :south] },
        x50_north:  ->(x) { [0, x + 100, :east] },
        x50_south:  ->(y) { [49, y + 100, :west] },
        x100_north: ->(x) { [x - 100, 199, :north] },
        x100_south: ->(x) { [99, x - 50, :west] },
        y0_east:    ->(y) { [99, 49 - y + 100, :west] },
        y0_west:    ->(y) { [0, 49 - y + 100, :east] },
        y50_east:   ->(y) { [y + 50, 49, :north] },
        y50_west:   ->(y) { [y - 50, 100, :south] },
        y100_east:  ->(y) { [149, 149 - y, :west] },
        y100_west:  ->(y) { [50, 149 - y, :east] },
        y150_west:  ->(y) { [y - 100, 0, :south] },
        y150_east:  ->(y) { [y - 100, 149, :north] }
      }.tap { |hash| hash.default_proc = proc { |_, key| pp "Please implement 50 wrapping for #{ key }." } }.freeze

      DIRS = {
        east:  ->(x, y) { [x + 1, y] },
        west:  ->(x, y) { [x - 1, y] },
        south: ->(x, y) { [x, y + 1] },
        north: ->(x, y) { [x, y - 1] }
      }.freeze

      def wrapped_pos(x, y, heading)
        val, axis = (heading in :east | :west) ? [y, 'y'] : [x, 'x']
        @wrapping[:"#{ axis }#{ val - (val % @board_size) }_#{ heading }"].call(val)
      end

      def step((x, y), heading, distance)
        new_x, new_y              = DIRS[heading].call(x, y)
        new_x, new_y, new_heading = @board[new_y][new_x] ? [new_x, new_y, heading] : wrapped_pos(x, y, heading)

        if @board[new_y][new_x] == '#'
          [x, y, heading]
        elsif distance == 1
          [new_x, new_y, new_heading]
        else
          step [new_x, new_y], new_heading, distance - 1
        end
      end

      TURN = {
        L: { east: :north, north: :west, west: :south, south: :east },
        R: { east: :south, south: :west, west: :north, north: :east }
      }.freeze

      def walk((x, y), heading, op)
        if op.is_a?(Symbol) # :L or :R
          [x, y, TURN[op][heading]]
        else
          # op is a distance
          step [x, y], heading, op
        end
      end

      HEADING_VALS = { east: 0, south: 1, west: 2, north: 3 }.freeze

      def part_one
        @wrapping = WRAPPINGS_FLAT
        part_two
      end

      def part_two
        x, y, heading = [@x_ranges[0].first, 0, :east]
        x, y, heading = @path.reduce([]) { |_, op| x, y, heading = walk([x, y], heading, op) }.flatten
        [(y + 1) * 1000, (x + 1) * 4, HEADING_VALS[heading]].sum
      end
    end
  end
end
