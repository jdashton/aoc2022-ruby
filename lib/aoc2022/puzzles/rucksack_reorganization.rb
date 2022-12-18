# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 3, we're organizing rucksacks.
    class RucksackReorganization
      def self.day03
        pri_list = File.open('input/day03.txt') { |file| RucksackReorganization.new file }
        puts "Day  3, Part One: the sum of the priorities is #{ pri_list.priority_sum }."
        puts "Day  3, Part Two: the sum of the priorities is #{ pri_list.badge_sum }."
        puts
      end

      def initialize(file)
        @sacks = file.readlines(chomp: true)
      end

      PRIORITIES = (('a'..'z').zip((1..26)) + ('A'..'Z').zip((27..52))).to_h

      def priority_sum
        @sacks.map { |sack| PRIORITIES[RucksackReorganization.find_common(sack)] }.sum
      end

      def self.find_common(sack)
        contents = sack.chars
        half     = contents.length / 2
        (contents[...half].to_set & contents[half..].to_set).first
      end

      def self.find_badges(sack_list)
        sack_list.map { |str| str.chars.to_set }.reduce(&:&)
      end

      def self.group_by_three((*ary, last), sack)
        ary + (last.length < 3 ? [last.push(sack)] : [last, [sack]])
      end

      def badge_sum
        @sacks
          .reduce([[]]) { |acc, sack| RucksackReorganization.group_by_three acc, sack }
          .map(&RucksackReorganization.method(:find_badges))
          .map(&:first)
          .map { |char| PRIORITIES[char] }
          .sum
      end
    end
  end
end
