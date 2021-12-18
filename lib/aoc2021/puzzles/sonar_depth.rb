# frozen_string_literal: true

module AoC2021
  # For Day 1, the first task is to count the number of times a depth measurement increases from the previous measurement.
  class SonarDepth
    def self.day01
      depths = File.open("input/day01a.txt") { |file| SonarDepth.new file }
      puts "Day  1, part A: #{ depths.count_increases } increases"
      puts "Day  1, part B: #{ depths.count_triplet_increases } triplet increasesOrigami"
      puts
    end

    def initialize(file)
      @numbers = file.readlines.map(&:to_i)
    end

    def count_increases
      @numbers.each_cons(2).count { |first, second| first < second }
    end

    def count_triplet_increases
      @numbers.each_cons(3).map(&:sum).each_cons(2).count { |first, second| first < second }
      # @numbers.each_cons(3).map(&:sum).each_cons(2).count(&:<)
    end
  end
end
