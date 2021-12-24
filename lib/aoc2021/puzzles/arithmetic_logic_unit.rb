# frozen_string_literal: true

require "set"

module AoC2021
  # Calculates conditions of victory for given plays and boards
  class ArithmeticLogicUnit
    def self.day23
      arithmetic_logic_unit = File.open("input/day24a.txt") { |file| ArithmeticLogicUnit.new file }
      puts "Day 24, part A: #{ arithmetic_logic_unit.largest_model_number } is the largest model number accepted by MONAD."
      # puts "Day 24, part B: #{ arithmetic_logic_unit.least_energy_unfolded }  is the
      # least energy required to organize all the arithmetic_logic_units."
      puts
    end

    def initialize(_file)
      @last_board  = nil
      @last_number = nil
    end

    def self.largest_model_number = 99_999_999_999_999

    ZS = [1, 1, 1, 1, 26, 26, 26, 1, 1, 26, 26, 26, 1, 26].freeze
    XS = [13, 15, 15, 11, -16, -11, -6, 11, 10, -10, -8, -11, 12, -15].freeze
    WS = [5, 14, 15, 16, 8, 9, 2, 13, 16, 6, 6, 9, 11, 5].freeze

    def self.calculate_one(digit, w, z = 0)
      # inp w
      # mul x 0
      # add x z
      # mod x 26
      # add x 13
      # eql x w
      # eql x 0
      x = (z % 26 + XS[digit]) == w ? 0 : 1

      # mul y 0
      # add y 25
      # mul y x
      # add y 1
      y = (25 * x) + 1

      # div z 1 or 26
      # mul z y
      z = z / ZS[digit] * y

      # mul y 0
      # add y w
      # add y 5
      # mul y x
      y = (w + WS[digit]) * x

      # add z y
      z += y
      z
    end
  end
end
