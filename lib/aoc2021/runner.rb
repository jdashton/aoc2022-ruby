# frozen_string_literal: true

require_relative "sonar_depth"

module AoC2021
  # The Runner class provides file loading services around the solution for each day.
  class Runner
    def self.start
      # Read and parse the input file for day 1.
      # Invoke Day01 with the input array.
      # Output the results.
      File.open("input/day01a.txt") do |file|
        print "Day 1, part A: "
        puts " #{SonarDepth.new(
          file.readlines.map(&:to_i)
        ).count_increases } increases"
      end

      File.open("input/day01a.txt") do |file|
        print "Day 1, part B: "
        puts " #{SonarDepth.new(
          file.readlines.map(&:to_i)
        ).count_triplet_increases } triplet increases"
      end
    end
  end
end
