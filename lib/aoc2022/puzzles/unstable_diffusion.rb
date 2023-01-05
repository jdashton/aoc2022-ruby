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
        @board      = file.readlines(chomp: true).map { _1.tr('.#', '01').to_i(2) }
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

      def trim
        @board.shift while @board.first.zero?
        @board.pop while @board.last.zero?
        @board = @board.map { _1 >> 1 } while @board.all? { (_1 & 1).zero? }
        self
      end

      def render
        trim
        # pp @board
        max_len = @board.map(&:bit_length).max
        "#{ @board.map { _1.to_s(2).tr('01', '.#').rjust(max_len, '.') }.join("\n") }\n"
      end

      # Reimplemented with bit strings, adapted from
      #  https://github.com/SLiV9/AdventOfCode2022/blob/3f770dfb2c511249f9b16aface949d88f3d059b4/src/bin/day23/main.rs#L443
      #
      def propose_and_move
        # Expand board as needed
        @board = @board.map { _1 << 1 } while @board.any? { _1 & 1 == 1 }
        @board.unshift(0) unless @board.first.zero?
        @board.push(0) unless @board.last.zero?
        @board.push(0) unless @board[-2].zero?

        any_elf_moved       = false
        two_prev_prop_south = prev_prop_stay = prev_prop_south = prev_prop_west = prev_prop_east = 0

        # In each iteration we propose moves for the middle row in the cons(3) window,
        # but actualize moves for the top row in that window.
        @board.each_cons(3).with_index do |rows, north_index|
          # Propose moves in and from rows[1]
          curr_prop_stay, curr_prop_north, curr_prop_south, curr_prop_west, curr_prop_east = propose_row_moves(rows)

          # Actualize proposed moves for rows[0]. These were proposed in the previous iteration.
          # East-west collisions are detected and resolved in propose_row_moves().
          # Detect and resolve north-south collisions.
          if (blocked = two_prev_prop_south & curr_prop_north).positive?
            two_prev_prop_south     &= ~blocked
            curr_prop_north         &= ~blocked
            @board[north_index - 1] |= blocked
            curr_prop_stay          |= blocked
          end

          arrived       = curr_prop_north | two_prev_prop_south | prev_prop_west | prev_prop_east
          any_elf_moved ||= arrived.positive?

          @board[north_index] = prev_prop_stay | arrived

          # Carry forward the proposal for row[1] into the next loop.
          two_prev_prop_south = prev_prop_south
          prev_prop_south     = curr_prop_south
          prev_prop_west      = curr_prop_west
          prev_prop_east      = curr_prop_east
          prev_prop_stay      = curr_prop_stay
        end

        @board[-2]    |= two_prev_prop_south
        any_elf_moved ||= two_prev_prop_south.positive?

        @directions = @directions.rotate

        any_elf_moved
      end

      NO_PROPOSAL = [0, 0, 0, 0, 0].freeze

      def propose_row_moves((north, current, south))
        # proposal positions are these, in this order:
        # stay [0], north [1], south [2], west [3], east [4]
        return NO_PROPOSAL if current.zero?

        north_west = north << 1
        north_east = north >> 1
        south_west = south << 1
        south_east = south >> 1
        above3     = ~(north_west | north | north_east)
        below3     = ~(south_west | south | south_east)
        west       = ~(current << 1)
        east       = ~(current >> 1)
        happy      = current & above3 & below3 & west & east
        unhappy    = current & ~happy
        north_prop = south_prop = west_prop = east_prop = 0
        @directions.each do |direction|
          # noinspection RubyCaseWithoutElseBlockInspection
          case direction
            when :north
              north_prop = unhappy & above3
              unhappy    &= ~north_prop
            when :south
              south_prop = unhappy & below3
              unhappy    &= ~south_prop
            when :west # comparing to shadow in the opposite direction
              from      = unhappy & east & ~north_east & ~south_east
              west_prop = from << 1
              unhappy   &= ~from
            when :east
              from      = unhappy & west & ~north_west & ~south_west
              east_prop = from >> 1
              unhappy   &= ~from
          end
          break if unhappy.zero?
        end
        if (east_west_blocked = west_prop & east_prop).positive?
          west_prop &= ~east_west_blocked
          east_prop &= ~east_west_blocked
          unhappy   |= (east_west_blocked << 1) | (east_west_blocked >> 1)
        end
        [happy | unhappy, north_prop, south_prop, west_prop, east_prop]
      end

      def spread_out(max_rounds = 10)
        while propose_and_move
          @rounds += 1
          break if @rounds > max_rounds
        end
        self
      end

      def count_spaces
        trim
        (@board.length * @board.map(&:bit_length).max) - @board.map { _1.to_s(2).chars.map(&:to_i).sum }.sum
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
