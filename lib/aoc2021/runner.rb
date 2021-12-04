# frozen_string_literal: true

require_relative "sonar_depth"
require_relative "pilot_commands"
require_relative "diagnostic_bits"

module AoC2021
  # The Runner class provides file loading services around the solution for each day.
  class Runner
    def self.start
      day01
    end

    def self.day01
      depths = File.open("input/day01a.txt") { |file| SonarDepth.new file }
      puts "Day 1, part A: #{depths.count_increases} increases"
      puts "Day 1, part B: #{depths.count_triplet_increases} triplet increases\n\n"

      day02
    end

    def self.day02
      commands = File.open("input/day02a.txt") { |file| PilotCommands.new file }
      puts "Day 2, part A: #{commands.exec_commands} product of horizontal position and depth"
      puts "Day 2, part B: #{commands.exec_with_aim} product of horizontal position and depth\n\n"

      day03
    end

    def self.day03
      commands = File.open("input/day03a.txt") { |file| DiagnosticBits.new file }
      puts "Day 3, part A: #{commands.power_consumption} product of horizontal position and depth"
      # puts "Day 2, part B: #{commands.exec_with_aim} product of horizontal position and depth\n\n"
    end
  end
end
