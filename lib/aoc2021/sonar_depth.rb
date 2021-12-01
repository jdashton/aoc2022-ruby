# frozen_string_literal: true

module AoC2021
  # For Day 1, the first task is to count the number of times a depth measurement increases from the previous measurement.
  class SonarDepth
    def initialize(numbers)
      @numbers = numbers
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
