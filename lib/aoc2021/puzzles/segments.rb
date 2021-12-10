# frozen_string_literal: true

require "set"
require "forwardable"

# Encapsulates operations on each line (input and output pairings)
class DigitLine
  extend Forwardable
  def_delegators "self.class", :make_dictionary, :digit
  attr_reader :output, :dictionary

  def initialize(input, output)
    @output      = output
    @output_sets = output.map { |word| Set.new(word.chars) }
    @dictionary  = make_dictionary input
  end

  def self.make_dictionary(input)
    input.map { |word| Set.new(word.chars) }
         .sort_by(&:length)
         .reduce({}) { |acc, set| acc.merge digit(acc, set) => set }
         .invert
  end

  def parse_and_sum(acc) = acc + @output_sets.reduce("") { |acm, set| acm + @dictionary[set].to_s }.to_i

  DIGIT_VALS  = { 2 => 1, 3 => 7, 4 => 4, 7 => 8 }.freeze
  DIGIT_CALCS = {
    5 => lambda { |acc, set|
      if (acc[1] - set).empty?
        3
      elsif (acc[4] - set).length == 1
        5
      else
        2
      end
    },
    6 => lambda { |acc, set|
      if (acc[4] - set).empty?
        9
      elsif (acc[1] - set).empty?
        0
      else
        6
      end
    }
  }.freeze

  def self.digit(acc, set)
    len = set.length
    DIGIT_VALS[len] || DIGIT_CALCS[len].call(acc, set)
  end
end

module AoC2021
  # Segments implements the solutions for Day 8.
  class Segments
    def initialize(file)
      @lines          = file.readlines(chomp: true)
                            .map { |line| line.split("|").map(&:strip).map(&:split) }
                            .map { |line| DigitLine.new(*line) }
      @outputs        = @lines.map(&:output)
      @output_lengths = @outputs.flatten.map(&:length).tally
    end

    def easy_digits = @output_lengths.reject { |key, _| [5, 6].include?(key) }.values.sum

    def sum_of_all_outputs = @lines.reduce(0) { |acc, line| line.parse_and_sum(acc) }
  end
end
