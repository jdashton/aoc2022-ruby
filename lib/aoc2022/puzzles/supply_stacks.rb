# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 5, we're playing Towers of Hanoi.
    class SupplyStacks
      def self.day05
        supply_stacks = File.open('input/day05.txt') { |file| SupplyStacks.new file }
        puts "Day  5, Part One: The top crates are #{ supply_stacks.top_crates }."
        puts "Day  5, Part Two: The top crates are #{ supply_stacks.top_crates_9001 }."
        puts
      end

      def initialize(file)
        crates, (_, *@procedure) = file.readlines(chomp: true).slice_before(/\A\z/).to_a
        @stacks                  = [nil] + SupplyStacks.parse_stacks(crates.reverse[1..])
        @stacks2                 = @stacks.map(&:dup)
      end

      def self.parse_stacks(levels)
        # What we have: ["[Z] [M] [P]", "[N] [C]    ", "    [D]    "]
        # What we want: [nil, ["Z", "N"], ["M", "C", "D"], ["P"]]
        levels
          .map(&method(:extract_crate_names))
          .transpose
          .map { |stack| stack[...(stack.index(' '))] }
      end

      def self.extract_crate_names(level)
        level.chars.each_slice(4).map { |crate| crate[1] }
      end

      def top_crates
        @procedure.each do |move_string|
          next unless /\Amove (?<num_crates>\d+) from (?<from_stack>\d+) to (?<to_stack>\d+)\z/ =~ move_string

          num_crates.to_i.times { @stacks[to_stack.to_i].push(@stacks[from_stack.to_i].pop) }
        end
        @stacks[1..].map(&:last).join
      end

      def top_crates_9001
        @procedure.each do |move_string|
          next unless /\Amove (?<num_crates>\d+) from (?<from_stack>\d+) to (?<to_stack>\d+)\z/ =~ move_string

          @stacks2[to_stack.to_i].push(*@stacks2[from_stack.to_i].pop(num_crates.to_i))
        end
        @stacks2[1..].map(&:last).join
      end
    end
  end
end
