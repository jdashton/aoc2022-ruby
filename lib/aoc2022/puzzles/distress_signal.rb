# frozen_string_literal: true

require "json"

module AoC2022
  module Puzzles
    # For Day 13, we're sorting distress signals.
    class DistressSignal
      def self.day13
        distress_signal = File.open("input/day12.txt") { |file| DistressSignal.new file }
        puts "Day 13, part A: #{ distress_signal.check_order } is the sum of the indices of pairs that are in the right order."
        # puts "Day 13, part B: #{ distress_signal.fewest_steps_downhill } is the fewest steps required."
        puts
      end

      def initialize(file)
        @lines = file.readlines(chomp: true)
        @sum   = 0
      end

      def self.compare(left, right)
        puts "1: comparing #{ left } <=> #{ right }"
        diff = left <=> right
        return diff if diff

        left  = [left] unless left.is_a? Array
        right = [right] unless right.is_a? Array
        puts "2: comparing #{ left } <=> #{ right }"
        diff = left <=> right
        pp diff
        return diff if diff

        left.each_with_index do |ary, i|
          return 1 unless right[i]

          diff = compare(ary, right[i])
          return diff if diff && diff != 0
        end
        0
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
            pp "outer: comparing #{ left } <=> #{ right }"
            DistressSignal.compare(left, right)
          end
        two    = sorted.index([[2]]) + 1
        six    = sorted.index([[6]]) + 1
        two * six
      end
    end
  end
end
