# frozen_string_literal: true

require "forwardable"

# Class LinesOfDigits holds the zeros and ones on each line of input.
class LineOfDigits
  extend Forwardable
  def_instance_delegators :@line, :length, :[], :map

  def initialize(bits_string)
    @line = bits_string.strip.chars.map(&:to_i)
  end

  def add_to_acc(acc) = acc.each_with_index { |zoo, idx| zoo.count @line[idx] }

  def to_i = map(&:to_s).join.to_i(2)
end

# Encapsulates operations on the collection of input lines.
class LinesArray
  def initialize(ary)
    @ary = ary
  end

  def acc_array = Array.new(@ary.first.length) { ZeroOrOne.new }

  def each_line(&block)
    @ary.reduce(acc_array, &block)
  end

  def find_common_lines(commonality, index)
    # Review the bit in position `index`, seeking the `most_or_least` common.
    # Filter lines to keep only lines that have that value in the `index` position.
    # If the results.length == 1, convert to an integer and return it.
    # Else find_common_lines(results, most_or_least, index + 1)
    desired_val  = desired_val(commonality, index)
    result_lines = @ary.filter { |line| line[index] == desired_val }
    return result_lines.first.to_i if result_lines.length == 1

    LinesArray.new(result_lines).find_common_lines(commonality, index + 1)
  end

  def oxygen_generator = find_common_lines(:more_common, 0)

  def co2_scrubber = find_common_lines(:less_common, 0)

  private

  def desired_val(commonality, index)
    @ary.reduce(ZeroOrOne.new) { |zoo, line| zoo.count line[index] }.send(commonality)
  end
end

# Accumulates the number of zeros and ones seen.
class ZeroOrOne
  def initialize
    @zero = @one = 0
  end

  def count(val)
    if val.zero?
      @zero += 1
    else
      @one += 1
    end
    self
  end

  def more_common = @zero > @one ? 0 : 1

  def less_common = @zero > @one ? 1 : 0
end

# Encapsulates operations on the collection of frequency distributions.
class ValuesArray
  def initialize(lines_of_digits)
    @values = lines_of_digits.each_line { |acc, ary| ary.add_to_acc(acc) }
  end

  def find_common_bits(&block) = @values.map(&block).map(&:to_s).join.to_i(2)

  def gamma = find_common_bits(&:more_common)

  def epsilon = find_common_bits(&:less_common)
end

module AoC2021
  # For Day 3, we run a diagnostic on the submarine's computer.
  class DiagnosticBits
    def initialize(file)
      #         00100
      #         11110
      #         10110
      # This should produce the following data structure in @values
      # [[1, 2], [2, 1], [0, 3], [1, 2], [3, 0]]
      # which means that in position zero we observed one 0 and two 1s,
      # in position one we observed two 0s and one 1,
      # in position two we observed no 0s and three 1s,
      # etc
      @lines_of_digits = LinesArray.new(file.readlines.map { |line| LineOfDigits.new(line) })
      @values          = ValuesArray.new(@lines_of_digits)
    end

    def power_consumption
      @values.gamma * @values.epsilon
    end

    def life_support_rating
      @lines_of_digits.oxygen_generator * @lines_of_digits.co2_scrubber
    end
  end
end
