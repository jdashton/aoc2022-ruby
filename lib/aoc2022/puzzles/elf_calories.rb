# frozen_string_literal: true

module AoC2022
  # For Day 1, elves are carrying calories.
  class ElfCalories
    def self.day01
      elves = File.open("input/day01.txt") { |file| ElfCalories.new file }
      puts "Day  1, part A: the Elf carrying the most Calories is carrying #{ elves.most_calories } calories."
      puts "Day  1, part B: top three Elves carrying the most Calories are carrying #{ elves.top_3_total } calories in total."
      puts
    end

    def initialize(file)
      @moves = file.readlines.map(&:to_i).reduce([0]) do |(*ary, last), num|
        ary + (num.zero? ? [last, 0] : [last + num])
      end
    end

    def most_calories
      @moves.max
    end

    def top_3_total
      @moves.sort[-3..].sum
    end
  end
end
