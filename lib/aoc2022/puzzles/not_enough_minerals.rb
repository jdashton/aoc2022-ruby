# frozen_string_literal: true

require 'forwardable'

module AoC2022
  module Puzzles
    # For Day 19, we're cracking geodes.
    class NotEnoughMinerals
      def self.day19
        not_enough_minerals = File.open('input/day19.txt') { |file| NotEnoughMinerals.new file }
        puts "Day 19, Part One: #{ not_enough_minerals.max_release(5) } is the most pressure you can release in 5 minutes."
        # puts "Day 19, Part Two: #{ not_enough_minerals.tuning_frequency(4_000_000) } is the tuning frequency."
        puts
      end

      attr_reader :blueprints

      extend Forwardable
      def_instance_delegators 'self.class', :run_blueprint, :max_rate_of_production

      def initialize(file)
        @blueprints = file.readlines(chomp: true).map { |line| Blueprint.new(*parse(line)) }
        # pp @blueprints
      end

      Blueprint = Data.define(:id, :ore_robot_cost, :clay_robot_cost, :obsidian_robot_cost_ore,
                              :obsidian_robot_cost_clay, :geode_robot_cost_ore, :geode_robot_cost_obsidian)

      # Blueprint 1:
      #   Each ore robot costs 4 ore.
      #   Each clay robot costs 2 ore.
      #   Each obsidian robot costs 3 ore and 14 clay.
      #   Each geode robot costs 2 ore and 7 obsidian.
      def parse(line)
        # /\A\D+(\d+)\D+(\d+)\D+(\d+)\D+(\d+)\D+(\d+)\D+(\d+)\D+(\d+)\D+\z/x =~ line
        /Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian./ =~ line
        $~.captures.map(&:to_i)
      end

      class State
        attr_reader :geodes

        def initialize(ore_bots, blueprint)
          @ore_bots  = ore_bots
          @blueprint = blueprint
          @geodes    = blueprint.id == 1 ? 9 : 12
        end

        def tick
          # ore_bots_collect_ore
          # build_clay_bots
        end
      end

      COLLECT_STRING_SINGULAR = "%d %s-collecting robot collects %d %s; you now have %d %s."
      COLLECT_STRING_PLURAL   = "%d %s-collecting robots collect %d %s; you now have %d %s."
      CRACK_STRING_SINGULAR   = "%d geode-cracking robot cracks %d geode; you now have %d geode%s."
      CRACK_STRING_PLURAL     = "%d geode-cracking robots crack %d geodes; you now have %d geode%s."

      def self.max_rate_of_production(bp)
        # puts "Under Blueprint #{ bp.id }, ore robots cost #{ bp.ore_robot_cost } ore. We start with 1."
        ore_bots = 1

        most_expensive_ore      = [bp.ore_robot_cost, bp.clay_robot_cost, bp.obsidian_robot_cost_ore, bp.geode_robot_cost_ore].max
        most_expensive_clay     = bp.obsidian_robot_cost_clay
        most_expensive_obsidian = bp.geode_robot_cost_obsidian

        ore = clay = obsidian = geodes = clay_bots = obsidian_bots = geode_bots = ore_new_bots = clay_new_bots = obsidian_new_bots = geode_new_bots = 0
        (1..24).each do |tick|
          puts "== Minute #{ tick } =="

          # Stop making robots except the geode ones if my resource per minute already allows me to build the most expensive
          # robot every minute. So if I already have 3 ore/min and the most expensive ore cost is also 3, there's no point in
          # building more ore robots. I don't have to worry about running out of ore since we can only build one robot per
          # minute anyway.

          # Make Geode Robots
          if ore >= bp.geode_robot_cost_ore && obsidian >= bp.geode_robot_cost_obsidian
            ore            -= bp.geode_robot_cost_ore
            obsidian       -= bp.geode_robot_cost_obsidian
            geode_new_bots += 1
            puts "Spend #{ bp.geode_robot_cost_ore } ore and #{ bp.geode_robot_cost_obsidian } obsidian to start building a geode-cracking robot."

            # Make Obsidian Robots
          elsif obsidian_bots < most_expensive_obsidian && ore >= bp.obsidian_robot_cost_ore && clay >= bp.obsidian_robot_cost_clay
            ore               -= bp.obsidian_robot_cost_ore
            clay              -= bp.obsidian_robot_cost_clay
            obsidian_new_bots += 1
            puts "Spend #{ bp.obsidian_robot_cost_ore } ore and #{ bp.obsidian_robot_cost_clay } clay to start building an obsidian-collecting robot."

            # Make Clay Robots
          elsif clay_bots < most_expensive_clay && ore >= bp.clay_robot_cost
            ore           -= bp.clay_robot_cost
            clay_new_bots += 1
            puts "Spend #{ bp.clay_robot_cost } ore to start building a clay-collecting robot."

            # Make Ore Robots
          elsif ore_bots < most_expensive_ore && ore >= bp.ore_robot_cost
            ore          -= bp.ore_robot_cost
            ore_new_bots += 1
            puts "Spend #{ bp.ore_robot_cost } ore to start building a ore-collecting robot."
          end

          # Harvest all materials
          # puts "#{ ore_bots } ore-collecting robot collects #{ ore_bots } ore; you now have #{ ore += ore_bots } ore."
          puts (ore_bots > 1 ? COLLECT_STRING_PLURAL : COLLECT_STRING_SINGULAR) % [ore_bots, 'ore', ore_bots, 'ore', (ore += ore_bots), 'ore']
          puts (clay_bots > 1 ? COLLECT_STRING_PLURAL : COLLECT_STRING_SINGULAR) % [clay_bots, 'clay', clay_bots, 'clay', (clay += clay_bots), 'clay'] if clay_bots.positive?
          puts (obsidian_bots > 1 ? COLLECT_STRING_PLURAL : COLLECT_STRING_SINGULAR) % [obsidian_bots, 'obsidian', obsidian_bots, 'obsidian', (obsidian += obsidian_bots), 'obsidian'] if obsidian_bots.positive?
          puts (geode_bots > 1 ? CRACK_STRING_PLURAL : CRACK_STRING_SINGULAR) % [geode_bots, geode_bots, (geodes += geode_bots), geodes > 1 ? 's' : ''] if geode_bots.positive?

          # Roll-out new robots
          if ore_new_bots.positive?
            puts "The new ore-collecting robot is ready; you now have #{ ore_bots += 1 } of them."
            ore_new_bots = 0
          end
          if clay_new_bots.positive?
            puts "The new clay-collecting robot is ready; you now have #{ clay_bots += 1 } of them."
            clay_new_bots = 0
          end
          if obsidian_new_bots.positive?
            puts "The new obsidian-collecting robot is ready; you now have #{ obsidian_bots += 1 } of them."
            obsidian_new_bots = 0
          end
          if geode_new_bots.positive?
            puts "The new geode-cracking robot is ready; you now have #{ geode_bots += 1 } of them."
            geode_new_bots = 0
          end

          puts
        end
        puts "#{ geodes } geodes cracked\n\n"
      end

      def self.show_tree(blueprint)
        puts "With Blueprint #{ blueprint.id }, to make 1 geode_bot, we need #{ blueprint.geode_robot_cost_ore } ore and #{ blueprint.geode_robot_cost_obsidian } obsidian,"
        puts "  plus at least #{ blueprint.obsidian_robot_cost_ore } ore and #{ blueprint.obsidian_robot_cost_clay } clay,"
      end

      def self.run_blueprint(blueprint)
        # We start with 1 ore-collecting robot.
        state = State.new(1, blueprint)
        # Building toward 24 ticks
        (1..1).each { |_tick| state.tick }
        max_rate_of_production(blueprint)
        blueprint.id * state.geodes
      end

      def quality_levels
        @blueprints.map { |bp| run_blueprint(bp) }.sum
      end
    end
  end
end
