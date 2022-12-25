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
  def to_snafu
    carry = false
    digits(5).map { |d|
      d += 1 if carry
      (carry = d > 2 ? CHARS[d] : false) || d
    }.tap { |ary| ary << 1 if carry }.reverse.join
  end
end

# Monkey-patching into Ruby's String class
class String
  def to_snafu_i
    borrow = false
    chars.reverse.map { |c|
      d      = (CHARS[c] || c.to_i) - (borrow ? 1 : 0)
      borrow = d > 2
      d
    }.map.with_index { |d, i| d * (5 ** i) }.sum
  end
end
