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
    IN = [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9].freeze

    def self.calculate_one(digit, w, z = 0)
      z /= ZS[digit] # either 1 (bno-op) or 26 (pop)
      z = (z * 26) + w + WS[digit] if w != ((z % 26) + XS[digit])
      pp [digit, w, z]
    end

    def self.one_place(place) = 9.downto(1) { |w| calculate_one(place, w, 0) }

    def self.stack_based
      zz = [0]
      IN.zip(XS, WS, ZS).each do |w, a, a2, d|
        last = zz.last
        zz.pop if d == 26
        zz.push w + a2 if w != last + a
        pp [w, zz.reduce(0) { (_1 * 26) + _2 }, zz]
      end
    end

    def self.state_space_search
      find = -> w, i, zz, path {
        if i == 14
          pp zz, path.join[0...14]
          return
        end
        a  = XS[i]
        a2 = WS[i]
        d  = ZS[i]
        if d == 26
          return if w - a != zz.last
          next_zz = zz[0...-1]
          9.downto 1 do |next_w|
            find[next_w, i + 1, next_zz, [*path, next_w]]
          end
        else
          next_zz = [*zz, w + a2]
          9.downto 1 do |next_w|
            find[next_w, i + 1, next_zz, [*path, next_w]]
          end
        end
      }
      9.downto 1 do |w|
        find[w, 0, [], [w]]
      end
      puts "Done"
    end
  end
end
