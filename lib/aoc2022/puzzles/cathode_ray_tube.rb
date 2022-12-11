# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 10, we're emulating a CRT.
    class CathodeRayTube
      def self.day10
        crt_program = File.open("input/day10.txt") { |file| CathodeRayTube.new file }
        puts "Day 10, part A: #{ crt_program.sum_of_six_strengths } is the sum of these six signal strengths."
        puts "Day 10, part B: The image looks like this:\n\n#{ crt_program.render_image }"
        puts
      end

      def initialize(file)
        @program_lines = file
                         .readlines(chomp: true)
                         .map(&:split)
                         .map { |line| (ins = line[0].to_sym) == :noop ? [ins] : [ins, line[1].to_i] }
      end

      def self.run_program(prog_lines)
        cycle_num  = 0
        x_register = 1
        samples    = []
        prog_lines.each do |instruction, value|
          cycle_num += 1
          samples << (cycle_num * x_register) if (cycle_num % 20).zero? && !(cycle_num % 40).zero?
          # noinspection RubyCaseWithoutElseBlockInspection
          if instruction == :addx
            cycle_num += 1
            samples << (cycle_num * x_register) if (cycle_num % 20).zero? && !(cycle_num % 40).zero?
            x_register += value
          end
          break if cycle_num > 220
        end
        samples.sum
      end

      def self.render(cycle_num, x_register)
        pos = (cycle_num % 40) - 1
        pos == x_register || pos - 1 == x_register || pos + 1 == x_register ? "#" : "."
      end

      def self.render_image(prog_lines)
        cycle_num  = 0
        x_register = 1
        image_data = ""
        prog_lines.each do |instruction, value|
          cycle_num  += 1
          image_data += render(cycle_num, x_register)
          image_data += "\n" if (cycle_num % 40).zero?
          next unless instruction == :addx

          cycle_num  += 1
          image_data += render(cycle_num, x_register)
          image_data += "\n" if (cycle_num % 40).zero?
          x_register += value
        end
        image_data
      end

      def sum_of_six_strengths
        CathodeRayTube.run_program @program_lines
      end

      def render_image
        CathodeRayTube.render_image @program_lines
      end
    end
  end
end
