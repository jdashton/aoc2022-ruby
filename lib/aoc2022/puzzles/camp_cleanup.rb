# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 4, we're cleaning up the camp.
    class CampCleanup
      def self.day04
        assigned_ranges = File.open('input/day04.txt') { |file| CampCleanup.new file }
        puts "Day  4, Part One: In #{ assigned_ranges.contained_ranges } assignment pairs one range fully contains the other."
        puts "Day  4, Part Two: In #{ assigned_ranges.overlapping_ranges } assignment pairs the ranges overlap."
        puts
      end

      def initialize(file)
        @range_pairs = file.readlines(chomp: true).map { |pair| pair.split(/[,-]/).map(&:to_i) }
      end

      def contained_ranges
        @range_pairs.reduce(0) do |acc, (a_left, a_right, b_left, b_right)|
          acc + ((a_left >= b_left && a_right <= b_right) || (b_left >= a_left && b_right <= a_right) ? 1 : 0)
        end
      end

      def overlapping_ranges
        @range_pairs.reduce(0) do |acc, (a_left, a_right, b_left, b_right)|
          acc + (b_left > a_right || a_left > b_right ? 0 : 1)
        end
      end
    end
  end
end
