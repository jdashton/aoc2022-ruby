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
      pp match_data, @target_x_range, @target_y_range
    end

    def highest_y
      # find_possible_xs
      max_y = @target_y_range.min.abs - 1 # min meaning lowest and farthest from zero
      max_y * (max_y + 1) / 2
    end

    def find_possible_xs
      pp @target_x_range
      (0..@target_x_range.max).map do |this_x|
        next nil unless this_x.positive?

        next nil unless (1..this_x).sum >= @target_x_range.min

        next [1] if @target_x_range.include? this_x

        # 15 + 14 = 29
        steps = this_x.downto(0).each_with_index.reduce([]) { |acc, (next_x, idx)|
          # pp acc, next_x, idx
          @target_x_range.include?((next_x..this_x).sum) ? acc << (idx + 1) : acc
          if next_x.zero? and @target_x_range.include?((next_x..this_x).sum)
            acc << Float::INFINITY
          end
          acc
        }

        next steps unless steps.empty?

        nil
      end
    end
  end
end
