# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 23, we're tracing a password.
    class UnstableDiffusion
      def self.day23
        unstable_diffusion = File.open('input/day23.txt') { |file| UnstableDiffusion.new file }
        puts "Day 23, Part One: #{ unstable_diffusion.part_one } is the final password."
        puts "Day 23, Part Two: #{ unstable_diffusion.part_two } is the final password."
        puts
      end

      DIRS = {
        north: ->(x, y) { [x, y - 1] },
        south: ->(x, y) { [x, y + 1] },
        west:  ->(x, y) { [x - 1, y] },
        east:  ->(x, y) { [x + 1, y] }
      }.freeze

      # :reek:FeatureEnvy
      def initialize(file)
        @dirs  = DIRS.keys
        @board = file.readlines(chomp: true).each_with_index.reduce(Set.new) do |line_acc, (line, y)|
          line.chars.each_with_index.reduce(line_acc) { |acc, (char, x)| char == '#' ? acc << [x, y] : acc }
        end
      end

      # Round:
      # 1. considering where to move
      # 2. actually moving
      #
      # Consider the 8 adjacent positions:
      # * All empty: stand pat
      # * N, NE and NW empty ? move N
      # * S, SE and SW empty ? move S
      # * W, NW and SW empty ? move W
      # * E, NE and SE empty ? move E
      #
      # Move as proposed if no other Elf proposed moving to the same spot, else stand pat.
      #
      # Finally, rotate the direction sequence, so that S is considered first in the 2nd round,
      # west in the 3rd round and so forth.
      #   directions = [:north, :south, :west, :east].rotate

      def render
        xs, ys = @board.to_a.transpose.map(&:minmax)

        Range.new(*ys).map { |y|
          Range.new(*xs).map { |x|
            @board.include?([x, y]) ? '#' : '.'
          }.join
        }.join("\n") + "\n"
      end

      def lonely?((x, y))
        [
          [x - 1, y - 1], [x, y - 1], [x + 1, y - 1],
          [x - 1, y], [x + 1, y],
          [x - 1, y + 1], [x, y + 1], [x + 1, y + 1]
        ].none? { |pos| @board.include?(pos) }
      end

      def empty_dir?((x, y), dir)
        new_x, new_y = DIRS[dir].call(x, y)
        (if dir in :north | :south
           [[x - 1, new_y], [x, new_y], [x + 1, new_y]]
         else
           [[new_x, y - 1], [new_x, y], [new_x, y + 1]]
         end.none? { |pos| @board.include?(pos) }) ?
          [new_x, new_y] :
          false
      end

      def propose_moves
        num_moves = 0
        new_board = @board.dup
        @proposed = @board.reduce({}) do |acc, elf|
          # pp [acc, elf]
          if lonely?(elf)
            acc
          else
            @dirs.reduce(acc) do |dir_acc, dir|
              if (new_pos = empty_dir?(elf, dir))
                num_moves += 1
                if @board.include?(DIRS[dir].call(*new_pos))
                  # puts "Possible conflict, proposing move from #{ elf } to #{ new_pos }"
                  dir_acc.merge!({ new_pos => ((dir_acc[new_pos] || []) << elf) })
                else
                  # puts "No conflict, moving elf from #{ elf } to #{ new_pos }"
                  new_board.delete(elf) << new_pos
                end
                break dir_acc
              else
                dir_acc
              end
            end
          end
        end

        @board = new_board
        num_moves
      end

      def actuate_moves
        # @board contains all the elves that could not move or did not need to move.
        # Using the list of proposed moves, update @board by deleting those
        # that can move and adding them in their new spot.

        @proposed.each { |key, props| @board.delete(props[0]) << key if props.length == 1 }
      end

      def spread_out(max_rounds = 10)
        @rounds = 1
        while propose_moves.positive?
          actuate_moves
          @dirs   = @dirs.rotate
          @rounds += 1
          break if @rounds > max_rounds
        end
        self
      end

      def count_spaces
        xs, ys = @board.to_a.transpose.map(&:minmax)
        ((1 + xs[1] - xs[0]) * (1 + ys[1] - ys[0])) - @board.size
      end

      def part_one
        spread_out.count_spaces
      end

      def part_two
        spread_out(985)
        @rounds
      end
    end
  end
end
