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

      # :reek:FeatureEnvy
      def initialize(file)
        @directions = %i[north south west east]
        @rounds     = 1
        @board      = file.readlines(chomp: true).each_with_index.reduce(Set.new) do |line_acc, (line, y)|
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

      def propose_moves = @candidates.each_with_object({}) { |elf, proposed_moves| propose_elf_move(proposed_moves, elf) }

      def propose_elf_move(proposed_moves, elf)
        # return unless @board.member?(elf)

        x, y    = elf
        left_x  = x - 1
        right_x = x + 1
        up_y    = y - 1
        down_y  = y + 1

        neighbor_positions = [
          [left_x, up_y], [x, up_y], [right_x, up_y],
          [left_x, y], [right_x, y],
          [left_x, down_y], [x, down_y], [right_x, down_y]
        ]
        return if (empty = neighbor_positions.map { |pos| !@board.include?(pos) }).all?

        if @directions.any? do |direction|
          # noinspection RubyCaseWithoutElseBlockInspection
          next unless (new_pos = case direction
                                   when :north then empty[0] && empty[1] && empty[2] && neighbor_positions[1]
                                   when :south then empty[5] && empty[6] && empty[7] && neighbor_positions[6]
                                   when :west then empty[0] && empty[3] && empty[5] && neighbor_positions[3]
                                   when :east then empty[2] && empty[4] && empty[7] && neighbor_positions[4]
                                 end)

          if ((other_elf, _) = proposed_moves[new_pos])
            @new_candidates << other_elf
            @new_candidates << elf
            proposed_moves.delete(new_pos)
          else
            proposed_moves[new_pos] = [elf, direction]
          end
        end
        else
          @new_candidates << elf # Elf could not move
        end
      end

      def spread_out(max_rounds = 10)
        @candidates     = @board.to_a
        @new_candidates = Array.new
        while (proposed = propose_moves).length.positive?
          # pp [@candidates.size, @board.size]
          # @board contains all the elves that could not move or did not need to move.
          # Using the list of proposed moves, update @board by deleting those
          # that can move and adding them in their new spot.

          # pp @new_candidates
          proposed.each do |new_pos, (old_pos, _)|
            @board.delete(old_pos) << new_pos
            @new_candidates << new_pos
          end
          proposed.each do |new_pos, (_, direction)|
            @new_candidates.push(*
                                 # noinspection RubyCaseWithoutElseBlockInspection
                                 case direction
                                   when :north then ((new_pos[0] - 1)..(new_pos[0] + 1)).reduce([]) { |acc, x| @board.include?((pos = [x, new_pos[1] - 1])) ? acc << pos : acc }
                                   when :south then ((new_pos[0] - 1)..(new_pos[0] + 1)).reduce([]) { |acc, x| @board.include?((pos = [x, new_pos[1] + 1])) ? acc << pos : acc }
                                   when :west then ((new_pos[1] - 1)..(new_pos[1] + 1)).reduce([]) { |acc, y| @board.include?((pos = [new_pos[0] - 1, y])) ? acc << pos : acc }
                                   when :east then ((new_pos[1] - 1)..(new_pos[1] + 1)).reduce([]) { |acc, y| @board.include?((pos = [new_pos[0] + 1, y])) ? acc << pos : acc }
                                 end
            )
            # pp @new_candidates
          end
          @directions = @directions.rotate
          @rounds     += 1
          break if @rounds > max_rounds
          @candidates     = @new_candidates.uniq
          @new_candidates = Array.new
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
