# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Calculates conditions of victory for given plays and boards
  class TrickShot
    extend Forwardable
    def_instance_delegators "self.class", :y_step

    def initialize(file)
      file.readline(chomp: true).match(/target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/)
      @target_x_range = Regexp.last_match(1).to_i..Regexp.last_match(2).to_i
      @target_y_range = Regexp.last_match(3).to_i..Regexp.last_match(4).to_i
    end

    def highest_y
      max_y = @target_y_range.min.abs - 1 # min meaning lowest and farthest from zero
      max_y * (max_y + 1) / 2
    end

    def count_valid_pairs
      find_possible_pairs(find_possible_xs).size
    end

    # Returns the y position the probe will have after `step_number` number of steps.
    def self.y_step(initial_y_velocity, step_number)
      (0..(step_number - 1)).reduce(0) { |acc, step| acc + (initial_y_velocity - step) }
    end

    def find_possible_pairs(x_steps)
      min_y = @target_y_range.min
      x_steps.each_with_index.each_with_object(Set[]) do |(x_step, x_idx), acc|
        next acc unless x_step

        (min_y..min_y.abs - 1).each do |y_idx|
          try_each_y acc, min_y, x_idx, x_step, y_idx
        end
      end
    end

    def find_possible_xs
      (0..@target_x_range.max).map do |this_x|
        steps = this_x.downto(0).each_with_index.each_with_object([]) do |(next_x, idx), acc|
          next acc unless @target_x_range.include?((next_x..this_x).sum)

          acc << (idx + 1)
          acc << Float::INFINITY if next_x.zero?
        end
        next steps unless steps.empty?

        nil
      end
    end

    private

    def try_each_y(acc, min_y, x_idx, x_step, y_idx)
      (x_step.first..x_step.last).each do |step|
        break if (y_step = y_step(y_idx, step)) < min_y

        acc << [x_idx, y_idx] if @target_y_range.include?(y_step)
      end
    end
  end
end
