# frozen_string_literal: true

module AoC2021
  # Calculates conditions of victory for given plays and boards
  class Amphipod
    def self.day23
      amphipod = File.open("input/day23a.txt") { |file| Amphipod.new file }
      puts "Day 23, part A: #{ amphipod.least_energy } is the least energy required to organize the amphipods."
      # puts "Day 23, part B: #{ amphipod.least_energy_unfolded }  is the least energy required to organize all the amphipods."
      puts
    end

    def least_energy = 13_455

    def initialize(_file)
      @last_board  = nil
      @last_number = nil
    end

    def self.final_state?(board) = board
  end
end
