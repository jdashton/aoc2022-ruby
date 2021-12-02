# frozen_string_literal: true

require_relative "sonar_depth"

module AoC2021
  # The Runner class provides file loading services around the solution for each day.
  class Runner
    def self.start
      depths = File.open("input/day01a.txt") { |file| SonarDepth.new(file.readlines.map(&:to_i)) }
      puts "Day 1, part A: #{depths.count_increases} increases"
      puts "Day 1, part B: #{depths.count_triplet_increases} triplet increases"
    end
  end
end
