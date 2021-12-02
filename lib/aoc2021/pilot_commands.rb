# frozen_string_literal: true

module AoC2021
  # For Day 2, we need to follow navigation commands to arrive at a new location.
  class PilotCommands
    def initialize(file)
      @commands = file.readlines.map(&:split).map { |cmd, amt| [cmd.to_sym, amt.to_i] }
    end

    def exec_commands
      h_pos, depth = @commands.reduce([0, 0]) do |acc, cmd_val|
        acc => [h_pos, depth]
        case cmd_val
        in [:down, val] then [h_pos, depth + val]
        in [:up, val] then [h_pos, depth - val]
        in [:forward, val] then [h_pos + val, depth]
        else acc
        end
      end

      h_pos * depth
    end

    def exec_with_aim
      h_pos, depth = @commands.reduce([0, 0, 0]) do |acc, cmd_val|
        acc => [h_pos, depth, aim]
        case cmd_val
        in [:down, val] then [h_pos, depth, aim + val]
        in [:up, val] then [h_pos, depth, aim - val]
        in [:forward, val] then [h_pos + val, depth + (aim * val), aim]
        else acc
        end
      end

      h_pos * depth
    end
  end
end
