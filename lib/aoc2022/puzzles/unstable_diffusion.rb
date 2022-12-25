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
        @lines = file.readlines(chomp: true)
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

      def propose_moves(board, directions)
        pp board
        pp directions
      end

      def part_one
        110
      end
    end
  end
end
