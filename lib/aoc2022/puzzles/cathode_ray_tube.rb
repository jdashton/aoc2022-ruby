# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 10, we're emulating a CRT.
    class CathodeRayTube
      def self.day10
        crt_program = File.open('input/day10.txt') { |file| CathodeRayTube.new file }
        puts "Day 10, Part One: #{ crt_program.sum_of_six_strengths } is the sum of these six signal strengths."
        puts "Day 10, Part Two: The image looks like this:\n\n#{ crt_program.render_image }"
        puts
      end

      def initialize(file)
        @program_lines = file.readlines(chomp: true)
                             .map(&:split)
                             .map { |ins, val| (ins = ins.to_sym) == :noop ? [ins] : [ins, val.to_i] }
      end

      def self.run_program(prog_lines)
        cycle_num = x_register = 1
        prog_lines.each_with_object([]) do |(instruction, value), acc|
          (instruction == :noop ? 1 : 2).times do
            acc << yield(cycle_num, x_register)
            cycle_num += 1
          end
          instruction == :addx && x_register += value
        end
      end

      def self.render(cycle_num, x_register)
        pos = (cycle_num - 1) % 40
        ((pos - 1)..(pos + 1)).member?(x_register) ? '#' : '.'
      end

      def self.sample_cycle(cycle_num)
        (cycle_num % 20).zero? && (cycle_num % 40).positive?
      end

      def sum_of_six_strengths
        CathodeRayTube.run_program(@program_lines) { |cycle_num, x_register|
          CathodeRayTube.sample_cycle(cycle_num) ? (cycle_num * x_register) : nil
        }.compact.sum
      end

      def render_image
        CathodeRayTube.run_program(@program_lines) { |cycle_num, x_register|
          (CathodeRayTube.render(cycle_num, x_register) + ((cycle_num % 40).zero? ? "\n" : ''))
        }.join
      end
    end
  end
end
