# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Calculates conditions of victory for given plays and boards
  class TrickShot
    # Encapsulates calculations around a probe.
    class Probe
      def initialize(x_vel, y_vel)
        @x_vel = x_vel
        @y_vel = y_vel
        @x_pos = @y_pos = 0
        @max_y = 0
      end

      def step
        @x_pos += @x_vel
        @y_pos += @y_vel
        @max_y = [@max_y, @y_pos].max
        @x_vel = if @x_vel.positive?
                   @x_vel - 1
                   # elsif @x_vel.negative?
                   #   @x_vel + 1
                 else
                   0
                 end
        @y_vel -= 1
      end
    end

    def initialize(file)
      match_data      = file.readline(chomp: true).match(/target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/)
      @target_x_range = Regexp.last_match(1).to_i..Regexp.last_match(2).to_i
      @target_y_range = Regexp.last_match(3).to_i..Regexp.last_match(4).to_i
      # pp match_data, @target_x_range, @target_y_range
    end

    def highest_y
      max_y = @target_y_range.min.abs - 1 # min meaning lowest and farthest from zero
      max_y * (max_y + 1) / 2
    end

    def count_valid_pairs
      find_possible_pairs(find_possible_xs).size
    end

    # Returns the y position the probe will have after `step_number` number of steps.
    def y_step(initial_y_velocity, step_number)
      (0..(step_number - 1)).reduce(0) { |acc, step| acc + (initial_y_velocity - step) }
    end

    def find_possible_pairs(x_steps)
      min_y = @target_y_range.min
      max_y = @target_y_range.min.abs - 1 # min meaning lowest and farthest from zero
      x_steps.each_with_index.reduce(Set[]) do |acc, (x_step, x_idx)|
        next acc unless x_step

        (min_y..max_y).each do |y_idx|
          # puts "Considering #{ y_idx } with #{ x_step }"
          (x_step.first..x_step.last).each do |step|
            y_step = y_step(y_idx, step)
            break if y_step < min_y

            acc += [[x_idx, y_idx]] if @target_y_range.include?(y_step)
          end
        end
        acc
      end
    end

    def find_possible_xs
      # pp @target_x_range
      (0..@target_x_range.max).map do |this_x|
        next nil unless this_x.positive?

        next nil unless (1..this_x).sum >= @target_x_range.min

        next [1] if @target_x_range.include? this_x

        # 15 + 14 = 29
        steps = this_x.downto(0).each_with_index.each_with_object([]) do |(next_x, idx), acc|
          @target_x_range.include?((next_x..this_x).sum) ? acc << (idx + 1) : acc
          acc << Float::INFINITY if next_x.zero? && @target_x_range.include?((next_x..this_x).sum)
        end
        next steps unless steps.empty?

        nil
      end
    end
  end
end
