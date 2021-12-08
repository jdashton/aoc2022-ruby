# frozen_string_literal: true

require 'set'

# Encapsulates operations on each line (input and output pairings)
class DigitLine
  attr_reader :output, :dictionary

  def initialize(input, output)
    @input       = input
    @input_sets  = input.map { |word| Set.new(word.chars) }
    @output      = output
    @output_sets = output.map { |word| Set.new(word.chars) }
    @dictionary  = make_dictionary
  end

  def make_dictionary
    one = four = nil
    @input_sets.sort_by(&:length).reduce({}) do |acc, set|
      acc.merge case set.length
                  when 2 then { (one = set) => 1 }
                  when 3 then { set => 7 }
                  when 4 then { (four = set) => 4 }
                  when 7 then { set => 8 }
                  when 5
                    if (one - set).empty?
                      { set => 3 }
                    elsif (four - set).length == 1
                      { set => 5 }
                    else
                      { set => 2 }
                    end
                  else
                    # length must be 6
                    if (one - set).length == 1
                      { set => 6 }
                    elsif (four - set).empty?
                      { set => 9 }
                    else
                      { set => 0 }
                    end
                end
    end
  end

  def parse_and_sum(acc)
    # pp @dictionary
    # pp @output_sets
    acc + @output_sets.reduce('') { |acm, set| acm + @dictionary[set].to_s }.to_i
  end
end

module AoC2021
  # CrabSubs implements the solutions for Day 8.
  class Segments
    def initialize(file)
      @lines          = file.readlines(chomp: true)
                            .map { |line| line.split("|").map(&:strip).map(&:split) }
                            .map { |line| DigitLine.new(*line) }
      @outputs        = @lines.map(&:output)
      @output_lengths = @outputs.flatten.map(&:length).tally
    end

    def easy_digits
      @output_lengths.reject { |k, _| [5, 6].include?(k) }.values.sum
    end

    def sum_of_all_outputs
      # pp @lines
      @lines.reduce(0) { |acc, line| line.parse_and_sum(acc) }
      # 5353
    end
  end
end
