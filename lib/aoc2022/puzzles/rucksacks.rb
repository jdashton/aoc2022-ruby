# frozen_string_literal: true

module AoC2022
  # For Day 2, we're playing Rock-Paper-Scissors.
  class Rucksacks
    def self.day03
      pri_list = File.open("input/day03.txt") { |file| Rucksacks.new file }
      puts "Day  3, part A: the sum of the priorities is #{ pri_list.priority_sum }."
      puts "Day  3, part B: the sum of the priorities is #{ pri_list.badge_sum }."
      puts
    end

    def initialize(file)
      @sacks = file.readlines(chomp: true)
    end

    PRIORITIES = (("a".."z").zip((1..26)) + ("A".."Z").zip((27..52))).to_h

    def priority_sum
      @sacks.map { |sack|
        contents = sack.chars
        half     = contents.length / 2
        PRIORITIES[(contents[...half].to_set & contents[half..].to_set).first]
      }.sum
    end

    def badge_sum
      @sacks
        .reduce([[]]) { |(*ary, last), sack| ary + (last.length < 3 ? [last.push(sack)] : [last, [sack]]) }
        .map { |sack_list|
          sack_list
            .map { |str|
              str.chars.to_set
            }
            .reduce(&:&)
        }
        .map(&:first)
        .map { |char| PRIORITIES[char] }
        .sum
    end
  end
end
