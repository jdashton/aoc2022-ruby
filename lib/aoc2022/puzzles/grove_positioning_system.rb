# frozen_string_literal: true

require 'forwardable'

module AoC2022
  module Puzzles
    # For Day 20, we're mixing a list.
    class GrovePositioningSystem
      def self.day20
        grove_positioning_system = File.open('input/day20.txt') { |file| GrovePositioningSystem.new file }
        puts "Day 20, Part One: #{ grove_positioning_system.mix } is the sum of the three numbers " \
             'that form the grove coordinates.'
        # puts "Day 20, Part Two: #{ grove_positioning_system.tuning_frequency(4_000_000) } is the tuning frequency."
        puts
      end

      def initialize(file)
        @numbers     = file.readlines(chomp: true).map(&:to_i)
        @length      = @numbers.length - 1
        @half_length = @length / 2
        prep_list
        # pp @numbers
        # pp @numbers.length
        # pp @list
        # pp @zero
        # puts "#{ @list[0].to_s }"
      end

      def prep_list
        @list = Array.new(@numbers.length) { |i| Node.new(@numbers[i]) }
        @list.each_with_index { |n, i| n.prev, n.next = [@list[i - 1], @list[i + 1]] }
        @list[-1].next = @list[0]
        @zero          = @list[@numbers.index 0]
      end

      # Fundamental data structure for a doubly-linked list
      class Node
        attr_reader :num

        def initialize(num, prev_node = nil, next_node = nil)
          @num       = num
          @prev_node = prev_node
          @next_node = next_node
        end

        def prev = @prev_node

        def next = @next_node

        def prev=(node)
          @prev_node = node
        end

        def next=(node)
          @next_node = node
        end

        def to_s = "<_#{ @num }_>"

        def inspect
          "GPS::Node: num=#{ @num }, prev=#{ @prev_node }, next=#{ @next_node }"
        end
      end

      def walk
        # puts 'walking'
        n      = @list.first
        result = []
        loop do
          result << n.num
          n = n.next
          break if n == @list.first
        end
        result
      end

      def walk_in_reverse
        n      = @list.first
        result = []
        loop do
          n = n.prev
          result << n.num
          break if n == @list.first
        end
        result.reverse
      end

      def mix
        @list.each do |n|
          # pp walk
          # pp walk_in_reverse
          # next if n.num.zero?
          ptr = n

          # Unlink n from the list
          n.prev.next, n.next.prev = [n.next, n.prev]
          # pp @list

          if (num = n.num).positive?
            num = num % @length
            num = -@length + num if num > @half_length
          else
            num = num % -@length
            num = @length - num if num > @half_length
          end

          # pp "-- differs: #{ num }, #{ n.num }" if num != n.num
          # pp "-- #{ @list.length }"
          if num.positive?
            # puts "Moving #{ num } to the right: positive"
            num.times { ptr = ptr.next }
          else
            # puts "Moving #{ num.abs } to the left: negative"
            (num.abs + 1).times { ptr = ptr.prev }
          end
          # puts " -- done moving, about to insert between #{ ptr } and #{ ptr.next }"

          ptr.next, n.prev, n.next, ptr.next.prev = [n, ptr, ptr.next, n]
          # pp @list
        end
        # pp walk
        # pp walk_in_reverse
        ptr = @zero
        Array.new(3).map {
          1000.times { ptr = ptr.next }
          pp ptr.num
        }.sum
      end

      MAGIC_NUM = 811589153

      def part_two
        @numbers = @numbers.map { _1 * MAGIC_NUM }
        prep_list
        9.times { mix }
        mix
      end
    end
  end
end
