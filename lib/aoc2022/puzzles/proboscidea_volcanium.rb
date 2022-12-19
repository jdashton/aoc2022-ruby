# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 16, we're opening valves.
    class ProboscideaVolcanium
      def self.day15
        proboscidea_volcanium = File.open('input/day16.txt') { |file| BeaconExclusionZone.new file }
        puts "Day 16, Part One: #{ proboscidea_volcanium.check_row(2_000_000) } is the most pressure you can release."
        # puts "Day 16, Part Two: #{ proboscidea_volcanium.tuning_frequency(4_000_000) } is the tuning frequency."
        puts
      end

      def initialize(file)
        @valves = file.readlines(chomp: true).to_h do |line|
          v = Valve.new(line)
          [v.valve_name, v]
        end
        # pp @valves
      end

      # This lets us handle valve parsing.
      class Valve
        attr_reader :valve_name, :flow_rate, :valve_list

        def initialize(line)
          /\AValve (?<valve_name>..) has flow rate=(?<flow_rate>\d+); tunnels? leads? to valves? (?<valve_list>.+)\z/ =~ line
          # pp $~
          @valve_name = valve_name.to_sym
          @flow_rate  = (f = flow_rate.to_i).positive? ? f : nil
          @valve_list = valve_list.split(', ').map(&:to_sym)
          # pp self
        end

        def details = [@valve_list, @flow_rate]

        def inspect
          "Valve #{ @valve_name }: rate #{ @flow_rate }, tunnels to #{ @valve_list }"
        end
      end

      def take_action(node, time_remaining, opened_list = [], prefix = '')
        # puts "#{prefix}Visiting #{ node } with #{ time_remaining } minutes and #{ opened_list }"
        # prefix  += "#{ node }::"
        current_valve         = @valves[node] # Current Valve
        valve_list, flow_rate = current_valve.details
        time_remaining        -= 1

        actions = time_remaining > 1 ? valve_list.map { |v| take_action(v, time_remaining, opened_list.dup, prefix) } : []
        if flow_rate && !opened_list.include?(node)
          actions << (flow_this_valve = time_remaining * flow_rate)
          if (time_remaining -= 1) > 1
            actions += valve_list.map { |v| flow_this_valve + take_action(v, time_remaining, opened_list.dup << node, prefix) }
          end
        end

        # puts "#{ prefix}#{actions}" " -- done at #{ prefix[..-3] }"
        # print '.'
        actions.max || 0
      end

      def max_release(minutes)
        start = :AA
        take_action(start, minutes)
      end
    end
  end
end
