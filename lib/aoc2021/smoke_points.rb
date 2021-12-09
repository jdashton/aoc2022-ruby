# frozen_string_literal: true

# Encapsulates operations on each line (input and output pairings)
class SmokePointLines
  def initialize(lines)
    @lines  = lines
    @border = Array.new(lines[0].length + 2, ":")
  end

  def make_heightmap
    [@border, *@lines.map { |line| ":#{ line }:" }.map(&:chars), @border]
  end
end

module AoC2021
  # Segments implements the solutions for Day 8.
  class SmokePoints
    def initialize(file)
      @heightmap = SmokePointLines.new(file.readlines(chomp: true)).make_heightmap
    end

    def risk_levels
      reduce_line(0) { |char, _, _| char.to_i + 1 }
    end

    def multiply_basins = basins.sort[-3..].reduce(1) { |acc, num| acc * (num || 1) }

    private

    def low_point_coords
      reduce_line([]) { |_, x_idx, y_idx| [[x_idx, y_idx]] }
    end

    def basins
      walk_basins low_point_coords
    end

    def reduce_line(init_val, &block)
      @heightmap.each_with_index.reduce(init_val) do |acc, (line, y_index)|
        acc + reduce_row(init_val, line, y_index, &block)
      end
    end

    def reduce_row(init_val, line, y_idx)
      line.each_with_index.reduce(init_val) do |acm, (char, x_idx)|
        next acm if char > "9"

        acm + (lowest_among_neighbours?(char, x_idx, y_idx) ? yield(char, x_idx, y_idx) : init_val)
      end
    end

    def lowest_among_neighbours?(char, x_idx, y_idx)
      neighbours(x_idx, y_idx).all?(&->(neighbour) { neighbour[0] > char })
    end

    def neighbours(x_index, y_index)
      this_row = @heightmap[y_index]
      [
        [this_row[x = x_index - 1], x, y_index],
        [this_row[x = x_index + 1], x, y_index],
        [@heightmap[y = y_index - 1][x_index], x_index, y],
        [@heightmap[y = y_index + 1][x_index], x_index, y]
      ]
    end

    def walk_basins(starting_points)
      starting_points.reduce([]) do |acc, (x, y)|
        @heightmap[y][x] = "v"
        acc + [1 + visit(neighbours(x, y))]
      end
    end

    def visit(queue)
      queue.reduce(0) do |acc, (_, x, y)|
        this_row = @heightmap[y]
        next acc unless this_row[x] < "9"

        this_row[x] = "v"
        acc + 1 + visit(neighbours(x, y))
      end
    end
  end
end
