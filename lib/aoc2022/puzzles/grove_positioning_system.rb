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

      extend Forwardable
      def_instance_delegators 'self.class', :find_sum

      def initialize(file)
        @numbers = file.readlines(chomp: true).map(&:to_i)
        @list    = @zero = nil
        prep_list
        # pp @numbers
        # pp @numbers.length
        # pp @list
        # pp @zero
        # puts "#{ @list[0].to_s }"
      end

      def prep_list
        @list = Array.new(@numbers.length) { |i| Node.new(@numbers[i]) }
        # noinspection RubyNilAnalysis
        @list&.each_with_index { |node, i| node.prev, node.next = [@list[i - 1], @list[i + 1] || @list.first] }
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

        def insert_after(other_node)
          @prev_node      = other_node
          @next_node      = new_next = other_node.next
          other_node.next = new_next.prev = self
        end

        def unlink
          @prev_node&.next = @next_node
          [@next_node&.prev = @prev_node, @num]
        end

        def walk_forward(num_steps)
          node = self
          num_steps.times { node = node.next }
          node
        end

        def walk_backward(num_steps)
          node = self
          num_steps.times { node = node.prev }
          node
        end

        def to_s = "<_#{ @num }_>"

        def inspect
          "GPS::Node: num=#{ @num }, prev=#{ @prev_node }, next=#{ @next_node }"
        end
      end

      def mix
        half_length = (length = @numbers.length - 1) / 2

        @list&.each do |node|
          ptr, num = node.unlink # returns the node that had been node's previous neighbor, and the value in the current node

          node.insert_after(if (num %= length) > half_length
                              num = length - num
                              ptr.walk_backward(num)
                            else
                              ptr.walk_forward(num)
                            end)
        end
      end

      def self.find_sum(ptr) = Array.new(3).map { (ptr = ptr.walk_forward(1000)).num }.sum

      def part_one
        mix
        find_sum(@zero)
      end

      MAGIC_NUM = 811_589_153

      def part_two
        @numbers = @numbers.map { _1 * MAGIC_NUM }
        prep_list
        10.times { mix }
        find_sum(@zero)
      end
    end
  end
end
