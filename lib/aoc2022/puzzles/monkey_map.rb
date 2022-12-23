# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 22, we're tracing a password.
    class MonkeyMap
      def self.day22
        monkey_map = File.open('input/day22.txt') { |file| MonkeyMap.new file }
        puts "Day 22, Part One: #{ monkey_map.part_one } is the final password."
        # puts "Day 22, Part Two: #{ monkey_map.part_two } is the final password."
        puts
      end

      # :reek:FeatureEnvy
      def initialize(file)
        @board, @x_ranges, @y_ranges, @path = parse(file.readlines(chomp: true))
        @wrapping                           = WRAPPINGS_FOUR
        @board_size                         = 4
      end

      def parse(lines)
        x_ranges, y_ranges = [[], []]

        board = lines[...-2].map.with_index do |line, y|
          x = line =~ /[.#]/

          x_ranges[y] = (x_range = x...line.length).minmax
          x_range.each do |x_prime|
            minmax            = y_ranges[x_prime] || [y, y]
            minmax[1]         = y if y > minmax.last
            y_ranges[x_prime] = minmax
          end
          Array.new(x) + line[x..].chars
        end
        [board, x_ranges, y_ranges, lines.last.split(/([LR])/).map { |op| (num = op.to_i); num.positive? ? num : op.to_sym }]
      end

      def render
        # pp @path
        # @board.each_with_index { |line, i| puts (" " * @x_ranges[i].first) + line.join }
      end

      def east((x, y), distance)
        distance.times do
          next_x   = (x < @x_ranges[y].last) ? x + 1 : @x_ranges[y].first
          next_pos = @board[y][next_x]
          if next_pos == '#'
            break
          else
            x = next_x
          end
        end
        x
      end

      def west((x, y), distance)
        distance.times do
          next_x   = (x > @x_ranges[y].first) ? x - 1 : @x_ranges[y].last
          next_pos = @board[y][next_x]
          if next_pos == '#'
            break
          else
            x = next_x
          end
        end
        x
      end

      def south((x, y), distance)
        distance.times do
          next_y   = (y < @y_ranges[x].last) ? y + 1 : @y_ranges[x].first
          next_pos = @board[next_y][x]
          if next_pos == '#'
            break
          else
            y = next_y
          end
        end
        y
      end

      def north((x, y), distance)
        distance.times do
          next_y   = (y > @y_ranges[x].first) ? y - 1 : @y_ranges[x].last
          next_pos = @board[next_y][x]
          if next_pos == '#'
            break
          else
            y = next_y
          end
        end
        y
      end

      WRAPPINGS_FOUR = {
        y4_east:  ->(y) { [7 - y + 12, 8, :south] },
        x8_south: ->(x) { [11 - x, 7, :north] },
        x4_north: ->(x) { [8, x - 4, :east] }
      }

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
      }

      WRAPPINGS_FOUR.default_proc  = proc { |hash, key| pp "Please implement 4 wrapping for #{ key }." }
      WRAPPINGS_FIFTY.default_proc = proc { |hash, key| pp "Please implement 50 wrapping for #{ key }." }

      def east_cube((x, y), distance)
        return [x, y, :east] if distance.zero?

        puts " -- at [#{ x }, #{ y }] heading east for #{ distance }"
        next_x, next_y, next_heading = (x < @x_ranges[y].last) ? x + 1 : @wrapping[:"y#{ y - y % @board_size}_east"].call(y)

        next_pos = @board[next_y || y][next_x]
        if next_pos == '#'
          [x, y, :east]
        else
          send :"#{next_heading || :east}_cube", [next_x, next_y || y], distance - 1
        end
      end

      def west_cube((x, y), distance)
        return [x, y, :west] if distance.zero?

        puts " -- at [#{ x }, #{ y }] heading west for #{ distance }"
        next_x, next_y, next_heading = (x > @x_ranges[y].first) ? x - 1 : @wrapping[:"y#{ y - y % @board_size}_west"].call(y)

        next_pos = @board[next_y || y][next_x]
        if next_pos == '#'
          [x, y, :west]
        else
          send :"#{next_heading || :west}_cube", [next_x, next_y || y], distance - 1
        end
      end

      def south_cube((x, y), distance)
        return [x, y, :south] if distance.zero?

        puts " -- at [#{ x }, #{ y }] heading south for #{ distance }"
        next_x, next_y, next_heading = (y < @y_ranges[x].last) ? [x, y + 1] : @wrapping[:"x#{ x - x % @board_size}_south"].call(x)
        next_pos                     = @board[next_y][next_x]
        # pp [next_x, next_y, next_heading, next_pos]
        if next_pos == '#'
          [x, y, :south]
        else
          send :"#{next_heading || :south}_cube", [next_x, next_y], distance - 1
        end
      end

      def north_cube((x, y), distance)
        return [x, y, :north] if distance.zero?

        puts " -- at [#{ x }, #{ y }] heading north for #{ distance }"
        next_x, next_y, next_heading = (y > @y_ranges[x].first) ? [x, y - 1] : @wrapping[:"x#{ x - x % @board_size}_north"].call(x)
        next_pos                     = @board[next_y][next_x]
        # pp [next_x, next_y, next_heading, next_pos]
        if next_pos == '#'
          [x, y, :north]
        else
          send :"#{next_heading || :north}_cube", [next_x, next_y], distance - 1
        end
      end

      def walk((x, y), heading, op)
        case op
          when :R
            # puts " -- turn Right"
            heading = case heading
                        when :east then :south
                        when :south then :west
                        when :west then :north
                        else :east
                      end
          when :L
            # puts " -- turn Left"
            heading = case heading
                        when :east then :north
                        when :north then :west
                        when :west then :south
                        else :east
                      end
          else
            # puts " -- walk #{ op } starting at #{ [x, y] } while heading #{ heading }."
            case heading
              when :east then x = east([x, y], op)
              when :west then x = west([x, y], op)
              when :south then y = south([x, y], op)
              else y = north([x, y], op)
            end
        end
        [[x, y], heading]
      end

      def walk_cube((x, y), heading, op)
        case op
          when :R
            # puts " -- turn Right"
            heading = case heading
                        when :east then :south
                        when :south then :west
                        when :west then :north
                        else :east
                      end
          when :L
            # puts " -- turn Left"
            heading = case heading
                        when :east then :north
                        when :north then :west
                        when :west then :south
                        else :east
                      end
          else
            # puts " -- walk #{ op } starting at #{ [x, y] } while heading #{ heading }."
            case heading
              when :east then x, y, heading = east_cube([x, y], op)
              when :west then x, y, heading = west_cube([x, y], op)
              when :south then x, y, heading = south_cube([x, y], op)
              else x, y, heading = north_cube([x, y], op)
            end
        end
        [[x, y], heading]
      end

      def part_one
        # render
        pos           = [@x_ranges.first.first, 0]
        heading       = :east
        x, y, heading = @path.reduce([]) { |_, op| pos, heading = walk(pos, heading, op) }.flatten
        # pp "#{ x }, #{ y }, #{ heading }"
        (y + 1) * 1000 + (x + 1) * 4 + (
          if heading == :east
            0
          else
            if heading == :south
              1
            else
              heading == :west ? 2 : 3
            end
          end)
      end

      def part_two
        if @board.size > 50
          @wrapping   = WRAPPINGS_FIFTY
          @board_size = 50
        end
        render
        pos           = [@x_ranges.first.first, 0]
        heading       = :east
        x, y, heading = @path.reduce([]) { |_, op| pos, heading = walk_cube(pos, heading, op) }.flatten
        pp [x, y, heading]
        pp (y + 1) * 1000 + (x + 1) * 4 + (heading == :east ? 0 : heading == :south ? 1 : heading == :west ? 2 : 3)
        # 5031
      end
    end
  end
end
