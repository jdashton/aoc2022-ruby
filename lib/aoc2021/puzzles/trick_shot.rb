# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Calculates conditions of victory for given plays and boards
  class TrickShot
    extend Forwardable
    def_instance_delegators "self.class", :y_step, :gauss

    def initialize(file)
      file.readline(chomp: true).match(/target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/)
      @target_x_range = Regexp.last_match(1).to_i..Regexp.last_match(2).to_i
      @target_y_range = Regexp.last_match(3).to_i..Regexp.last_match(4).to_i
      @lowest_y       = @target_y_range.min
      @max_y_range    = @lowest_y..@lowest_y.abs - 1
    end

    def self.gauss(val) = val * (val + 1) / 2

    def highest_y = gauss(@max_y_range.max)

    def count_valid_pairs
      find_possible_pairs(find_possible_xs).size
    end

    # Returns the y position the probe will have after `step_number` number of steps.
    def self.y_step(initial_y_velocity, step_number)
      (0..(step_number - 1)).reduce(0) { |acc, step| acc + (initial_y_velocity - step) }
    end

    def find_possible_pairs(x_steps)
      x_steps.each_with_index.reduce(Set[], &method(:with_each_x))
    end

    def find_possible_xs
      (0..@target_x_range.max).map(&method(:try_each_x))
    end

    private

    def try_each_x(this_x)
      this_x.downto(0).each_with_index.reduce([]) do |acc, (next_x, idx)|
        next acc unless @target_x_range.include?((next_x..this_x).sum)

        acc.push(*[idx + 1, next_x.zero? ? Float::INFINITY : []].flatten)
      end
    end

    def with_each_x(acc, (x_step, x_idx))
      return acc if x_step.empty?

      @max_y_range.reduce(acc) { |acm, y_idx| acm.merge(try_each_y(x_step, x_idx, y_idx)) }
    end

    def try_each_y(x_step, x_idx, y_idx)
      pairs = []
      (x_step.first..x_step.last).each do |step|
        break if (y_step = y_step(y_idx, step)) < @lowest_y

        pairs << [x_idx, y_idx] if @target_y_range.include?(y_step)
      end
      pairs
    end
  end
end
