# frozen_string_literal: true

require 'forwardable'

module AoC2022
  module Puzzles
    # For Day 20, we're mixing a list.
    class GrovePositioningSystem
      def self.day20
        grove_positioning_system = File.open('input/day20.txt') { |file| GrovePositioningSystem.new file }
        puts "Day 20, Part One: #{ grove_positioning_system.part_one } is the sum of the three numbers " \
             'that form the grove coordinates.'
        puts "Day 20, Part Two: #{ grove_positioning_system.part_two } is the sum of the three numbers " \
             'that form the grove coordinates.'
        puts
      end

      def initialize(file)
        @numbers     = file.readlines(chomp: true).map(&:to_i)
        @length      = @numbers.length - 1 # We use this at a time when one node has been removed from the list.
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
        @list.each_with_index { |n, i| n.prev, n.next = [@list[i - 1], @list[i + 1] || @list.first] }
        @zero = @list[@numbers.index 0]
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
          # Unlink n from the list
          n.prev.next, n.next.prev, ptr = [n.next, n.prev, n.prev]

          if (num = n.num).positive?
            num = num % @length
            num = -@length + num if num > @half_length
          else
            num = num % -@length
            num = @length + num if -num > @half_length
          end

          if num.positive?
            num.times { ptr = ptr.next }
          else
            (-num).times { ptr = ptr.prev }
          end

          ptr.next, n.prev, n.next, ptr.next.prev = [n, ptr, ptr.next, n]
        end
      end

      def find_sum
        ptr = @zero
        Array.new(3).map {
          1000.times { ptr = ptr.next }
          ptr.num
        }.sum
      end

      def part_one
        mix
        find_sum
      end

      MAGIC_NUM = 811_589_153

      def part_two
        @numbers = @numbers.map { _1 * MAGIC_NUM }
        prep_list
        10.times { mix }
        find_sum
      end
    end
  end
end
