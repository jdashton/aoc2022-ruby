# frozen_string_literal: true

module AoC2021
  # Origami implements the solutions for Day 13.
  class Polymers
    def initialize(file)
      @lines        = file.readlines(chomp: true)
      @template     = @lines.shift
      @instructions = {}
      @lines.shift # dump an empty line
      @lines.each do |line|
        pair, new_p         = line.split(" -> ")
        @instructions[pair] = new_p + pair[1]
      end
    end

    def insert(num)
      (1..num).reduce(@template) do |current, _|
        current.chars
               .each_cons(2)
               .map(&:join)
               .reduce(current[0]) do |acc, pair|
          acc + (@instructions[pair] || "")
        end
      end
    end

    def self.difference(str)
      min, max = str.chars.tally.values.minmax
      max - min
    end
  end
end
