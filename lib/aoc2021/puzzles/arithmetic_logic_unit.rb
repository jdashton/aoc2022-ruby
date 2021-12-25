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

    DIVS  = [1, 1, 1, 1, 26, 26, 26, 1, 1, 26, 26, 26, 1, 26].freeze
    ADD1  = [13, 15, 15, 11, -16, -11, -6, 11, 10, -10, -8, -11, 12, -15].freeze
    ADD2  = [5, 14, 15, 16, 8, 9, 2, 13, 16, 6, 6, 9, 11, 5].freeze
    INPUT = [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9].freeze

    def self.stack_to_s(stack)
      letters = []
      while stack > 0
        letters.push(stack % 26)
        stack -= letters.last
        stack /= 26
      end
      letters.reverse.map { |letter| to_ltr(letter) }.join("|")
    end

    def self.to_ltr(num) = ("A".ord + num).chr

    def self.calculate_one(digit, w, z = 0)
      last = z % 26
      print "#{ digit < 10 ? " " : "" }#{ digit } - #{ w } - #{ stack_to_s z }:      "
      print DIVS[digit] == 26 ? "\tpop #{ to_ltr(z % 26) }" : ""
      z /= DIVS[digit] # either 1 (no-op) or 26 (pop)

      if w != (last + ADD1[digit])
        print "\tpush #{ to_ltr(w + ADD2[digit]) }"
        print "\tBecause #{ to_ltr(w) } != #{ to_ltr(last) } + #{ ADD1[digit] } (#{ to_ltr(last + ADD1[digit]) }), "
        z = (z * 26) + w + ADD2[digit] 
        print "pushed #{ to_ltr(w) } + #{ to_ltr(ADD2[digit]) } = #{ to_ltr(w + ADD2[digit]) }"
      else
        print "\tBecause #{ to_ltr(w) } == #{ to_ltr(last) } + #{ ADD1[digit] } (#{ to_ltr(last + ADD1[digit]) }), took no further action"
      end
      
      puts
      z
    end

    def self.replay_number(number)
      puts "Running the code for #{ number }."
      z = 0
      number.to_s.chars.each_with_index do |w, i|
        z = calculate_one(i, w.to_i, z)
      end
      puts "14 -   - #{ stack_to_s z }: "
    end

    def self.one_place(place) = 9.downto(1) { |w| calculate_one(place, w, 0) }

    def self.stack_based
      zz = [0]
      INPUT.zip(ADD1, ADD2, DIVS).each do |w, a, a2, d|
        last = zz.last
        zz.pop if d == 26
        zz.push w + a2 if w != last + a
        pp [w, zz.reduce(0) { |acc, num| (acc * 26) + num }, zz]
      end
    end

    # These answers totally based on https://notes.dt.in.th/20211224T121217Z7595

    def self.state_space_search
      model_numbers = []

      find = lambda { |w, i, zz, path|
        next_zz = if DIVS[i] == 26
                    zz[0..-2] # pop and forget the last element
                  else
                    zz + [w + ADD2[i]] # push w + a2
                  end
        9.downto 1 do |next_w|
          next if DIVS[i + 1] == 26 && next_zz.last != next_w - ADD1[i + 1]

          return model_numbers << (path << next_w).join if i == 12

          find[next_w, i + 1, next_zz, path + [next_w]]
        end
      }
      9.downto 1 do |w|
        find[w, 0, [], [w]]
      end
      puts "Largest model number: #{ model_numbers.max }, smallest model number: #{ model_numbers.min }."
    end
  end
end
