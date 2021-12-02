# frozen_string_literal: true

module AoC2021
  # For Day 2, we need to follow navigation commands to arrive at a new location.
  class PilotCommands
    def initialize(commands: [], file: nil)
      @commands = if commands.empty?
                    file.readlines.map do |line|
                      command, amount = line.split
                      [command.to_sym, amount.to_i]
                    end
                  else
                    commands
                  end
    end

    def exec_commands
      h_pos = depth = 0

      @commands.each do |cmd, val|
        case cmd
        when :down then depth += val
        when :up then depth -= val
        when :forward then h_pos += val
        end
      end

      h_pos * depth
    end

    def exec_with_aim
      h_pos = depth = aim = 0

      @commands.each do |cmd, val|
        case cmd
        when :down then aim += val
        when :up then aim -= val
        when :forward
          h_pos += val
          # increases your depth by your aim multiplied by X
          depth += aim * val
        end
      end

      h_pos * depth
    end
  end
end
