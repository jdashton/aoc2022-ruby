# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 21, we're mixing a list.
    class MonkeyMath
      def self.day21
        monkey_math = File.open('input/day21.txt') { |file| MonkeyMath.new file }
        puts "Day 21, Part One: the monkey named root will yell #{ monkey_math.find_advanced(:root) }."
        puts "Day 21, Part Two: #{ monkey_math.part_two } is the number I yell."
        puts
      end

      # :reek:FeatureEnvy
      def initialize(file)
        @monkeys = file.readlines(chomp: true).to_h do |line|
          monkey, job = line.split(': ')
          [monkey.to_sym, (num = job.to_i).positive? ? num : job.split.map(&:to_sym)]
        end
      end

      def find_advanced(monkey)
        left, op, right = @monkeys[monkey]
        return left unless op

        left, right = [find_advanced(left), find_advanced(right)]
        if [left, right].all? { _1.is_a? Integer }
          left.send(op, right)
        else
          [left, op, right]
        end
      end

      INV_OPS = { :/ => :*, :+ => :-, :* => :/, :- => :+ }.freeze

      def invert((left, op, right), equals, value)
        return value unless op

        inv_op = INV_OPS[op]
        return invert(left, equals, value.send(inv_op, right)) if right.is_a? Integer

        if op == :-
          invert(right, equals, left.send(:-, value))
        else
          invert(right, equals, value.send(inv_op, left))
        end
      end

      def part_two
        @monkeys[:humn]          = :human
        root_left, _, root_right = @monkeys[:root]

        left  = find_advanced(root_left)
        right = find_advanced(root_right)
        invert(left, :==, right)
      end
    end
  end
end
