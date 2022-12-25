# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 25, we're tracing a password.
    class FullOfHotAir
      def self.day25
        full_of_hot_air = File.open('input/day25.txt') { |file| FullOfHotAir.new file }
        puts "Day 25, Part One: #{ full_of_hot_air.part_one } is the SNAFU number to enter."
        # puts "Day 25, Part Two: #{ full_of_hot_air.part_two } is the SNAFU number to enter."
        puts
      end

      # :reek:FeatureEnvy
      def initialize(file)
        @lines = file.readlines(chomp: true)
      end

      def part_one
        @lines.map(&:to_snafu_i).sum.to_snafu
      end
    end
  end
end

CHARS = { 3 => '=', 4 => '-', 5 => '0', '=' => -2, '-' => -1 }.freeze

# Monkey-patching into Ruby's Integer class
class Integer
  def to_snafu = digits(5).each_with_index.reduce([]) { |acc, (digit, i)| Integer.snafu_digit(acc, digit, i) }.reverse.join

  def self.snafu_digit(acc, digit, index)
    digit += 1 if acc[index]
    acc[...index] + [CHARS[digit] || digit] + (digit > 2 ? [1] : [])
  end
end

# Monkey-patching into Ruby's String class
class String
  def to_snafu_i = chars.reverse.map.with_index { |character, i| (CHARS[character] || character.to_i) * (5 ** i) }.sum
end
