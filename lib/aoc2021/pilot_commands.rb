# frozen_string_literal: true

# Position describes the tuplet of horizontal position and depth.
class Position
  def initialize
    @h_pos = 0
    @depth = 0
  end

  def down(distance)
    tap { @depth += distance }
  end

  def up(distance)
    tap { @depth -= distance }
  end

  def forward(distance)
    tap { @h_pos += distance }
  end

  def answer
    @h_pos * @depth
  end
end

# PositionWithAim reflects new understanding for part B of the puzzle.
class PositionWithAim < Position
  def initialize
    super
    @aim = 0
  end

  def down(amount)
    tap { @aim += amount }
  end

  def up(amount)
    tap { @aim -= amount }
  end

  def forward(distance)
    tap do
      @h_pos += distance
      @depth += @aim * distance
    end
  end
end

module AoC2021
  # For Day 2, we need to follow navigation commands to arrive at a new location.
  class PilotCommands
    def initialize(file)
      @commands = file.readlines.map(&:split).map { |cmd, amt| [cmd.to_sym, amt.to_i] }
    end

    def exec_commands
      @commands.reduce(Position.new) { |acc, cmd_val| acc.send(*cmd_val) }.answer
    end

    def exec_with_aim
      @commands.reduce(PositionWithAim.new) { |acc, cmd_val| acc.send(*cmd_val) }.answer
    end
  end
end
