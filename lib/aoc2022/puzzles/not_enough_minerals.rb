# frozen_string_literal: true

require 'forwardable'

module AoC2022
  module Puzzles
    # For Day 19, we're cracking geodes.
    class NotEnoughMinerals
      def self.day19
        not_enough_minerals = File.open('input/day19.txt') { |file| NotEnoughMinerals.new file }
        puts "Day 19, Part One: #{ not_enough_minerals.quality_levels } is the most pressure you can release in 5 minutes."
        # puts "Day 19, Part Two: #{ not_enough_minerals.tuning_frequency(4_000_000) } is the tuning frequency."
        puts
      end

      attr_reader :blueprints

      extend Forwardable
      def_instance_delegators 'self.class', :run_blueprint, :max_rate_of_production

      def initialize(file)
        @blueprints = file.readlines(chomp: true).map { |line| parse(line) }
        pp @blueprints.first(3).map { |bp| quality bp }.reduce(:*)
      end

      # Blueprint 1:
      #   Each ore robot costs 4 ore.
      #   Each clay robot costs 2 ore.
      #   Each obsidian robot costs 3 ore and 14 clay.
      #   Each geode robot costs 2 ore and 7 obsidian.
      def parse(line)
        # /\A\D+(\d+)\D+(\d+)\D+(\d+)\D+(\d+)\D+(\d+)\D+(\d+)\D+(\d+)\D+\z/x =~ line
        /Blueprint \d+: Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./ =~ line
        # pp $~.captures.map(&:to_i)
        [[0, -$6.to_i, 0, -$5.to_i], [0, 0, -$4.to_i, -$3.to_i], [0, 0, 0, -$2.to_i], [0, 0, 0, -$1.to_i]]
      end

      def quality(blueprint)
        puts "Considering #{ blueprint }"
        # states is [[resources, robots]]
        states = [[[0, 0, 0, 0], [0, 0, 0, 1]]]

        26.times do
          children = []
          states.each do |resources, robots|
            blueprint.each.with_index do |costs, robot_type|
              _resources = resources.zip(costs).map(&:sum)
              if _resources.none?(&:negative?)
                _resources          = _resources.zip(robots).map(&:sum)
                _robots             = robots.clone
                _robots[robot_type] += 1
                children.push [_resources, _robots]
              end
            end
            resources = resources.zip(robots).map(&:sum)
            children.push [resources, robots]
          end

          states = children.uniq.max_by(5000) do |resources, robots|
            resources.zip(robots).flatten
          end
        end
        states.max.first.first
      end

      def quality_levels
        # @blueprints.map { |bp| run_blueprint(bp) }.sum
        33
      end
    end
  end
end
