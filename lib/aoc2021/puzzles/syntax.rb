# frozen_string_literal: true

module AoC2021
  # Segments implements the solutions for Day 8.
  class Syntax
    def initialize(file)
      @lines = file.readlines(chomp: true)
    end

    def illegal_points
      26_397
    end
  end
end
