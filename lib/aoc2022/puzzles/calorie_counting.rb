# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 1, elves are carrying calories.
    class CalorieCounting
      def self.day01
        elves = File.open('input/day01.txt') { |file| CalorieCounting.new file }
        puts "Day  1, Part One: the Elf carrying the most Calories is carrying #{ elves.most_calories } calories."
        puts "Day  1, Part Two: top three Elves carrying the most Calories are carrying #{ elves.top_3_total } calories in total."
        puts
      end

      def initialize(file)
        @elves = file.readlines.map(&:to_i).reduce([0]) do |(*ary, last), num|
          ary + (num.zero? ? [last, 0] : [last + num])
        end
      end

      def most_calories
        @elves.max
      end

      def top_3_total
        @elves.sort[-3..].sum
      end
    end
  end
end
