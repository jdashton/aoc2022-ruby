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
    def self.day09
      smoke_points = File.open("input/day09a.txt") { |file| SmokePoints.new file }
      puts "Day  9, part A: #{ smoke_points.risk_levels } sum of the risk levels of all low points"
      puts "Day  9, part B: #{ smoke_points.multiply_basins } product of three largest basin sizes"
      puts
    end

    def initialize(file)
      @heightmap = SmokePointLines.new(file.readlines(chomp: true)).make_heightmap
    end

    def risk_levels
      search_heightmap(0) { |char, _, _| char.to_i + 1 }
    end

    def multiply_basins = basin_loop([], low_point_coords).sort[-3..].reduce(&:*)

    private

    def low_point_coords
      search_heightmap([]) { |_, x_idx, y_idx| [[nil, x_idx, y_idx]] }
    end

    def search_heightmap(init_val, &block)
      @heightmap.each_with_index.reduce(init_val) do |acc, (line, y_index)|
        acc + search_row(init_val, line, y_index, &block)
      end
    end

    def search_row(init_val, line, y_idx)
      line.each_with_index.reduce(init_val) do |acc, (char, x_idx)|
        next acc if char > "9"

        acc + (lowest_among_neighbours?(char, x_idx, y_idx) ? yield(char, x_idx, y_idx) : init_val)
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

    def basin_loop(init_val, starting_points)
      starting_points.reduce(init_val) do |acc, (_, x, y)|
        basin_block acc, x, y
      end
    end

    def basin_block(acc, x, y)
      return acc if (this_row = @heightmap[y])[x] >= "9"

      this_row[x]   = "v"
      visit_results = 1 + basin_loop(0, neighbours(x, y))
      acc + (acc.is_a?(Array) ? [visit_results] : visit_results)
    end
  end
end
