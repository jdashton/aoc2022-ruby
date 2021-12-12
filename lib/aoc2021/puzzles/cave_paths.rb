# frozen_string_literal: true

module AoC2021
  # OctopusFlashes implements the solutions for Day 11.
  class CavePaths
    extend Forwardable
    def_instance_delegators :@successes, :count
    attr_reader :successes

    def initialize(file)
      @list      = file.readlines(chomp: true).map(&:chars).map { |line| line.map(&:to_i) }
      @successes = Set.new('A'..'J')
    end
  end
end
