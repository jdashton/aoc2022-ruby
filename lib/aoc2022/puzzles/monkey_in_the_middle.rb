# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 11, we're playing keep-away.
    class MonkeyInTheMiddle
      def self.day11
        monkey_in_the_middle = File.open('input/day11.txt') { |file| MonkeyInTheMiddle.new file }
        puts "Day 11, Part One: #{ monkey_in_the_middle.most_active_monkeys } is the level of monkey business after 20 rounds."
        puts "Day 11, Part Two: #{ monkey_in_the_middle.ten_thousand_monkeys } is the level of monkey business after 10k rounds."
        puts
      end

      # Finally! Some data with real structure!
      class Monkey
        attr_reader :inspections, :true_target, :false_target, :test

        def initialize(text_block)
          /Monkey\ \d: \s*
             Starting\ items:\ (?<items>\d+(?:,\ \d+)*) \s*
             Operation:\ new\ =\ old\ (?<operation>[*+]\ (?:\d+|old)) \s*
             Test:\ divisible\ by\ (?<divisor>\d+) \s*
               If\ true:\ throw\ to\ monkey\ (?<true_monkey>\d) \s*
               If\ false:\ throw\ to\ monkey\ (?<false_monkey>\d)/x =~ text_block.join

          @items                                           = fix_items items
          op_data                                          = fix_op operation
          @test, @true_target, @false_target, @inspections = [divisor, true_monkey, false_monkey, 0].map(&:to_i)

          @operation = op_data[1] == :old ? ->(item) { item.send op_data[0], item } : ->(item) { item.send(*op_data) }
        end

        def fix_op(operation)
          operation.split.map { |v| (x = v.to_i).positive? ? x : v.to_sym }
        end

        def fix_items(items)
          items.split(', ').map(&:to_i)
        end

        def catch(item) = @items.push(item)

        def take_turn(true_monkey, false_monkey, mod_worry = nil)
          @items.each do |item|
            @inspections += 1
            item         = @operation.call(item)
            item         = mod_worry ? item % mod_worry : item / 3
            ((item % @test).zero? ? true_monkey : false_monkey).catch item
          end
          @items = []
        end

        def to_s
          <<~TEXT
            Monkey:
              Starting items: #{ @items }
              Operation: new = old #{ @operation }
              Test: divisible by #{ @test }
                If true: throw to monkey #{ @true_target }
                If false: throw to monkey #{ @false_target }
          TEXT
        end

        def inspect
          "<Monkey: #{ @items }, #{ @operation }, #{ @test }, #{ @true_target }, #{ @false_target }>"
        end
      end

      def initialize(file)
        monkey_lines = file.readlines(chomp: true)
        @monkeys     = monkey_lines.slice_before(/\AMonkey /).map { |text_block| Monkey.new(text_block) }
      end

      def most_active_monkeys
        20.times do
          @monkeys.each { |monkey| monkey.take_turn @monkeys[monkey.true_target], @monkeys[monkey.false_target] }
        end
        @monkeys.map(&:inspections).sort.last(2).reduce(&:*)
      end

      def ten_thousand_monkeys
        factor_product = @monkeys.map(&:test).reduce(&:*)
        10_000.times { @monkeys.each { |m| m.take_turn @monkeys[m.true_target], @monkeys[m.false_target], factor_product } }
        @monkeys.map(&:inspections).sort.last(2).reduce(&:*)
      end
    end
  end
end
