# frozen_string_literal: true

require 'json'

module AoC2022
  module Puzzles
    # For Day 13, we're sorting distress signals.
    class DistressSignal
      def self.day13
        distress_signal = File.open('input/day13.txt') { |file| DistressSignal.new file }
        puts "Day 13, Part One: #{ distress_signal.check_order } is the sum of the indices of pairs that are in the right order."
        puts "Day 13, Part Two: #{ distress_signal.decoder_key } is the fewest steps required."
        puts
      end

      def initialize(file)
        @lines = file.readlines(chomp: true)
        @sum   = 0
      end

      def self.compare(left, right)
        # puts "1: comparing #{ left } <=> #{ right }"
        case [left, right]
          in [Integer, nil]
            1
          in [Array, nil]
            1
          in [nil, Integer]
            -1
          in [nil, Array]
            -1
          in [Integer, Integer]
            # puts "comparing two integers"
            left <=> right
          in [Array, Array]
            # puts "comparing two arrays"
            diff = left.zip(right).reduce(-1) do |_, pair|
              d = compare(*pair)
              # puts "comparison returned #{ d.inspect }"
              break d unless d&.zero?

              d
            end
            diff.zero? && right.length > left.length ? -1 : diff
          in [Integer, Array]
            # puts "left was not an array: wrapping and recursing"
            compare [left], right
          in [Array, Integer]
            # puts "right was not an array: wrapping and recursing"
            compare left, [right]
          else
          # puts "not matched"
        end
      end

      def check_order
        @lines.each_slice(3).with_index do |(left, right, _), i|
          left  = JSON.parse left
          right = JSON.parse right
          # puts "#{i + 1} left:  #{left}"
          # puts "#{i + 1} right: #{right}"
          # pp DistressSignal.compare(left, right)
          # puts
          @sum  += (i + 1) if (diff = DistressSignal.compare(left, right)) && diff < 1
        end
        @sum
      end

      def decoder_key
        sorted =
          (@lines.filter { |line| !line.empty? }.map(&JSON.method(:parse)) + [[[2]], [[6]]])
          .sort do |left, right|
            # puts "outer: comparing #{ left } <=> #{ right }"
            DistressSignal.compare(left, right)
          end
        two    = sorted.index([[2]]) + 1
        six    = sorted.index([[6]]) + 1
        two * six
      end
    end
  end
end
