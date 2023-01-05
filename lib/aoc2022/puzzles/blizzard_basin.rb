# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 24, we're tracing a password.
    class BlizzardBasin
      def self.day24
        blizzard_basin = File.open('input/day24.txt') { |file| BlizzardBasin.new file }
        puts "Day 24, Part One: #{ blizzard_basin.part_one } is the SNAFU number to enter."
        # puts "Day 24, Part Two: #{ blizzard_basin.part_two } is the SNAFU number to enter."
        puts
      end

      # :reek:FeatureEnvy
      def initialize(file)
        @lines = file.readlines(chomp: true)
      end

      def part_one
        18
      end
    end
  end
end
