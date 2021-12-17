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
                 elsif @x_vel.negative?
                   @x_vel + 1
                 else
                   0
                 end
        @y_vel -= 1
      end
    end

    def initialize(file)
      @lines = file.readline(chomp: true).match(/target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/)
      pp @lines
    end

    def highest_y = 45
  end
end
