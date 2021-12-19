# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Calculates math operations on Snailfish numbers for Day 18
  class Snailfish
    extend Forwardable
    def_instance_delegators "self.class", :y_step, :gauss

    def self.day18
      snailfish = File.open("input/day18a.txt") { |file| Snailfish.new file }
      puts "Day 18, part A: #{ snailfish.magnitude_of_sum } is the magnitude of the final sum."
      # puts "Day 18, part B: #{snailfish.permutations} is the largest magnitude of any sum of two different snailfish numbers."
      puts
    end

    attr_reader :number

    def initialize(file)
      @lines  = file.readlines(chomp: true)
      @number = @lines.reduce("") { |acc, line| addition(acc, line) }
    end

    def permutations
      @lines.permutation(2).map { |line1, line2| magnitude_of_sum(addition(line1, line2)) }.max
    end

    def magnitude_of_sum(num_string = @number)
      magnitude_of_term(num_string)[0]
    end

    def magnitude_of_term(num_string)
      # pp num_string
      case num_string
        when /\A\[(\d),(\d)\]/
          # puts "whole-term handling"
          [(3 * Regexp.last_match(1).to_i) + (2 * Regexp.last_match(2).to_i), num_string[5..]]
        when /\A\[/
          # puts "term opened"
          term1, remnant = magnitude_of_term(num_string[1..])
          term2, remnant = magnitude_of_term(remnant[1..])
          # puts "returning 3 * #{ term1 } + 2 * #{ term2 } and #{ remnant[1..] }"
          [(3 * term1) + (2 * term2), remnant[1..]]
        when /\A(\d)/
          # puts "single-number handling"
          [Regexp.last_match(1).to_i, num_string[1..]]
        else
          # puts "default handling for #{ num_string[0] }"
          [0, num_string[1..]]
      end
    end

    def addition(term1, term2)
      return term2 if term1.empty?

      reduce "[#{ term1 },#{ term2 }]"
    end

    def reduce(number)
      # "[[[[[9,8],1],2],3],4]" becomes "[[[[0,9],2],3],4]"
      # raise "malformed number doesn't start with [" if number[0] != "["

      # puts "#{ number }"

      index = 1
      level = 1
      while level.positive?
        if level > 4
          # Explode this term
          # puts "number is #{number[index..]}"
          num1, num2, termlen = /\A(\d+),(\d+)/.match(number[index..]) { |md| [md[1], md[2], md[1].size + 1 + md[2].size] }
          # pp Regexp.last_match
          # print "Exp: [#{ $1 }, #{ $2 }]"
          # print "exploded:"
          # num1              = Regexp.last_match(1).to_i
          # num2              = Regexp.last_match(2).to_i
          # termlen           = Regexp.last_match(1).length + 1 + Regexp.last_match(2).length
          # TODO: try limiting the length of string to search back and forward for \d+.
          lpre, lnum, lpost = number[0..index - 2].rpartition(/(?<=\D)(\d+)(?=\D)/)
          # /\d+$/.match(lpre) do |md|
          #   lnum = md[0] + lnum
          #   lpre = md.pre_match
          # end
          # puts "#{ lpre } - #{ lnum } - #{ lpost }"
          rpre, rnum, rpost = number[index + termlen + 1..].partition(/(?<=\D)(\d+)(?=\D)/)
          # puts "#{ rpre } - #{ rnum } - #{ rpost }"
          new_number = "#{
            lpre.empty? ? "" : lpre + (lnum.to_i + num1.to_i).to_s }#{ lpost }0#{
            rpost.empty? ? rpre : rpre + (rnum.to_i + num2.to_i).to_s + rpost }"
          # puts " -- returning #{ new_number }"
          return reduce(new_number)
        else
          case number[index]
            when "["
              level += 1
            when "]"
              level -= 1
          end
        end
        index += 1
      end

      # Look for a split.
      /[[:digit:]][[:digit:]]+/.match(number) do |md|
        # print "Split: #{ md[0] }  "
        # print "splitted:"
        return reduce("#{ md.pre_match }[#{ md[0].to_i / 2 },#{ md[0].to_i.fdiv(2).ceil }]#{ md.post_match }")
      end

      number
    end
  end
end
