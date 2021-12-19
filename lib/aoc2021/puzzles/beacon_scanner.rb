# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Resolves positions of scanners and probes
  class BeaconScanner
    extend Forwardable
    def_instance_delegators "self.class", :y_step, :gauss

    def self.day19
      beacon_scaner = File.open("input/day19a.txt") { |file| BeaconScanner.new file }
      puts "Day 19, part A: #{ beacon_scanner.num_probes } unique probes visible to these scanners"
      # puts "Day 19, part B: #{snailfish.permutations} is the largest magnitude of any sum of two different snailfish numbers."
      puts
    end

    def initialize(file)
      @lines  = file.readlines(chomp: true)
    end

    def num_probes = 79
  end
end
