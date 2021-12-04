# frozen_string_literal: true

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
      @lines_of_digits = file.readlines.map(&:strip).map(&:chars)
      acc_array        = Array.new(@lines_of_digits[0].length) { Array.new(2, 0) }
      @values          = @lines_of_digits.each_with_object(acc_array) do |ary, acc|
        ary.map(&:to_i).each_with_index { |digit, idx| acc[idx][digit] += 1 }
      end
    end

    def power_consumption
      @values.map { |zeros, ones| zeros > ones ? 0 : 1 }.map(&:to_s).join.to_i(2) *
        @values.map { |zeros, ones| zeros < ones ? 0 : 1 }.map(&:to_s).join.to_i(2)
    end

    def life_support_rating
      oxygen_generator = 1

      # og_bit_criteria

      co2_scrubber = 230
      oxygen_generator * co2_scrubber
    end
  end
end
