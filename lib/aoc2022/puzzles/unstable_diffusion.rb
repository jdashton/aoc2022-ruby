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
        while @board.all? { _1 & 1 == 0 }
          @board = @board.map { _1 >> 1 }
        end
        self
      end

      def render
        trim
        # pp @board
        max_len = @board.map(&:bit_length).max
        "#{ @board.map { _1.to_s(2).tr('01', '.#').rjust(max_len, '.') }.join("\n") }\n"
      end

      def propose_and_move
        # Expand board as needed
        while @board.any? { _1 & 1 == 1 }
          @board = @board.map { _1 << 1 }
        end
        @board.unshift(0) unless @board.first.zero?
        @board.push(0) unless @board.last.zero?
        @board.push(0) unless @board[-2].zero?

        # RUST self.is_active = false;
        any_elf_moved = false

        # RUST let mut prev_south = Row::default();
        prev_prev_south = prev_prop_stay = prev_prop_south = prev_prop_west = prev_prop_east = 0

        # RUST let mut curr = Proposal::default();
        # RUST propose(
        # RUST   &mut curr,
        # RUST   self.data[1],
        # RUST   self.data[0],
        # RUST   self.data[2],
        # RUST &self.proposal_sequence,
        # RUST );
        # RUST self.data[0] = curr.north;
        # RUST let mut next;
        # RUST for r_of_prev in 0..(self.height - 3)
        # RUST   {
        @board.each_cons(3).with_index do |rows, index_of_north_row|
          # rows are north, current, south

          # RUST     let r_of_current = r_of_prev + 1;
          # RUST   let r_of_next = r_of_prev + 2;
          # RUST   next = Proposal::default();
          # RUST   propose(
          # RUST     &mut next,
          # RUST     self.data[r_of_next],
          # RUST       self.data[r_of_next - 1],
          # RUST       self.data[r_of_next + 1],
          # RUST   &self.proposal_sequence,
          # RUST   );
          curr_prop_stay, curr_prop_north, curr_prop_south, curr_prop_west, curr_prop_east = propose_row_moves(rows)

          # RUST     let blocked = prev_south & next.north;
          # RUST   resolve_block(blocked, &mut prev_south, &mut self.data[r_of_prev]);
          # RUST   resolve_block(blocked, &mut next.north, &mut next.stay);
          # RUST   let blocked = curr.less & curr.more;
          # RUST   resolve_block_l(blocked, &mut curr.less, &mut curr.stay);
          # RUST   resolve_block_m(blocked, &mut curr.more, &mut curr.stay);
          if (blocked = prev_prev_south & curr_prop_north).positive?
            prev_prev_south, @board[index_of_north_row - 1] = resolve_block(blocked, prev_prev_south, @board[index_of_north_row - 1])
            curr_prop_north, curr_prop_stay                 = resolve_block(blocked, curr_prop_north, curr_prop_stay)
          end

          # RUST   let arrived = prev_south | curr.less | curr.more | next.north;
          arrived       = prev_prev_south | prev_prop_west | prev_prop_east | curr_prop_north

          # RUST   if !arrived.is_empty()
          # RUST     {
          # RUST       self.is_active = true;
          # RUST     }
          any_elf_moved = true if arrived.positive?

          # RUST     self.data[r_of_current] = curr.stay | arrived;
          @board[index_of_north_row] = prev_prop_stay | arrived

          # RUST     prev_south = curr.south;
          prev_prev_south = prev_prop_south

          # RUST     curr = next;
          prev_prop_stay  = curr_prop_stay
          prev_prop_south = curr_prop_south
          prev_prop_west  = curr_prop_west
          prev_prop_east  = curr_prop_east
          # RUST     }
        end
        # RUST     self.data[self.height - 2] |= prev_south;
        @board[-2] |= prev_prev_south
        any_elf_moved = true if prev_prev_south.positive?

        # RUST     self.proposal_sequence.rotate_left(1);
        @directions = @directions.rotate

        any_elf_moved
      end

      def propose_row_moves((north, current, south))
        proposal = Array.new(5, 0)
        # proposal positions are these, in this order:
        # stay [0], north [1], south [2], west [3], east [4]
        return proposal if current.zero?

        west_shadow = current >> 1
        east_shadow = current << 1
        above3      = north | (north >> 1) | (north << 1)
        below3      = south | (south >> 1) | (south << 1)
        happy       = current & ~west_shadow & ~east_shadow & ~above3 & ~below3
        unhappy     = current & ~happy
        @directions.each do |direction|
          # noinspection RubyCaseWithoutElseBlockInspection
          case direction
            when :north
              proposal[1] = unhappy & ~above3
              unhappy     &= ~proposal[1]
            when :south
              proposal[2] = unhappy & ~below3
              unhappy     &= ~proposal[2]
            when :west # comparing to shadow in the opposite direction
              from        = unhappy & ~west_shadow & ~(north >> 1) & ~(south >> 1)
              proposal[3] = from << 1
              unhappy     &= ~from
            when :east
              from        = unhappy & ~east_shadow & ~(north << 1) & ~(south << 1)
              proposal[4] = from >> 1
              unhappy     &= ~from
          end
        end
        if (east_west_blocked = proposal[3] & proposal[4]).positive?
          proposal[3] &= ~east_west_blocked
          proposal[4] &= ~east_west_blocked
          unhappy     |= (east_west_blocked << 1) | (east_west_blocked >> 1)
        end
        proposal[0] = happy | unhappy
        proposal
      end

      def resolve_block(blocked, proposed, backup)
        [proposed & ~blocked, backup | blocked]
      end

      def spread_out(max_rounds = 10)
        while propose_and_move
          # puts "Round #{ @rounds }\n#{ render }\n"
          @rounds += 1
          break if @rounds > max_rounds
        end
        # pp @board
        self
      end

      def count_spaces
        trim
        @board.length * @board.map(&:bit_length).max - @board.map { _1.to_s(2).chars.map(&:to_i).sum }.sum
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
