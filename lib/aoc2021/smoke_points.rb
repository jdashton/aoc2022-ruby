# frozen_string_literal: true

# Encapsulates operations on each line (input and output pairings)
module AoC2021
  # Segments implements the solutions for Day 8.
  class SmokePoints
    def initialize(file)
      lines      = file.readlines(chomp: true)
      border     = Array.new(lines[0].length + 2, ":")
      @heightmap = [border, *lines.map { |line| ":#{ line }:" }.map(&:chars), border]
      # pp @heightmap
    end

    def risk_levels
      @heightmap.each_with_index.reduce(0) do |acc, (line, y_index)|
        # pp line, y_index
        acc + line.each_with_index.reduce(0) do |acm, (char, x_index)|
          next acm if char > "9"

          # pp neighbours if neighbours.all? { |neighbour| neighbour > char }
          acm + (neighbours(x_index, y_index).all? { |neighbour| neighbour[0] > char } ? char.to_i + 1 : 0)
        end
      end
    end

    def low_point_coords
      @heightmap.each_with_index.reduce([]) do |acc, (line, y_index)|
        # pp line, y_index
        acc + line.each_with_index.reduce([]) do |acm, (char, x_index)|
          next acm if char > "9"

          # pp neighbours if neighbours.all? { |neighbour| neighbour > char }
          acm + (neighbours(x_index, y_index).all? { |neighbour| neighbour[0] > char } ? [[char, x_index, y_index]] : [])
        end
      end
    end

    def basins
      # basins_with_edges = @heightmap.map { |row|
      #   row.map { |height| height > "8" ? ":" : height }
      # }
      # pp basins_with_edges
      lpcs = low_point_coords
      walk_basins(lpcs)
    end

    def multiply_basins = basins.sort[-3..-1].reduce(1) { |acc, i| acc * (i || 1) }

    private

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
      puts "walk_basins with #{starting_points}"
      starting_points.reduce([]) do |acc, (char, x, y)|
        # pp @heightmap
        puts "\nacc is now #{acc}"
        puts "------------------------ Beginning to visit [#{x},#{y}]"
        @heightmap[y][x] = "v"
        this_pool_size   = 1 + visit(neighbours(x, y))
        puts "This pool has size #{this_pool_size}."
        acc + [this_pool_size]
      end
    end

    def visit(queue)
      queue.reduce(0) do |acc, (val, x, y)|
        puts "Visiting #{ @heightmap[y][x] } at [#{ x },#{ y }]"
        next acc unless @heightmap[y][x] < "9"

        acc              += 1
        @heightmap[y][x] = "v"
        puts "  -- member of a pool"
        puts "  -- going to visit neighbours of [#{x},#{y}]"
        size = visit(neighbours(x, y))
        puts "  -- [#{x},#{y}] had #{size} new neighbours in the pool"
        puts "  -- total seen now #{ acc + size }"
        acc + size
      end
    end
  end
end
