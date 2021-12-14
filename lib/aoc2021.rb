# frozen_string_literal: true

require_relative "aoc2021/version"
require_relative "aoc2021/runner"

# The AoC2021 module contains implementations of solutions for each puzzle in the Advent of Code for 2021.
module AoC2021
  def self.start
    Runner.start
  end

  def self.day14b
    polymers = File.open("input/day14a.txt") { |file| Polymers.new file }
    puts "#{ polymers.process(40) } difference between the most and least common elements after 40 iterations"
  end
end
