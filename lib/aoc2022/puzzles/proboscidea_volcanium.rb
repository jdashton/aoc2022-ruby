# frozen_string_literal: true

require 'forwardable'

module AoC2022
  module Puzzles
    # For Day 16, we're opening valves.
    class ProboscideaVolcanium
      def self.day16
        proboscidea_volcanium = File.open('input/day16.txt') { |file| ProboscideaVolcanium.new file }
        puts "Day 16, Part One: #{ proboscidea_volcanium.max_release(5) } is the most pressure you can release in 5 minutes."
        # puts "Day 16, Part Two: #{ proboscidea_volcanium.tuning_frequency(4_000_000) } is the tuning frequency."
        puts
      end

      extend Forwardable
      def_instance_delegators 'self.class', :parse

      def initialize(file)
        @valves = file.readlines(chomp: true).to_h { |line| parse(line) }
      end

      def self.parse(line)
        /\AValve (?<valve_name>..) has flow rate=(?<flow_rate>\d+); tunnels? leads? to valves? (?<valve_list>.+)\z/ =~ line
        [valve_name.to_sym, [valve_list.split(', ').map(&:to_sym), (fr = flow_rate.to_i).positive? ? fr : nil]]
      end

      def take_action(node, time_remaining, opened_list = [])
        valve_list, flow_rate = @valves[node]

        actions = (time_remaining -= 1) > 1 ? valve_list.map { take_action(_1, time_remaining, opened_list.dup) } : []
        if flow_rate && !opened_list.include?(node)
          actions << (flow_this_valve = time_remaining * flow_rate)
          actions << (flow_this_valve + take_action(node, time_remaining, opened_list << node))
        end

        actions.max || 0
      end

      def max_release(minutes)
        start = :AA
        take_action(start, minutes)
      end
    end
  end
end
