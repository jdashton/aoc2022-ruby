# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 6, we're looking for message headers
    class TreetopTreeHouse
      def self.day08
        tree_grid = File.open("input/day08.txt") { |file| TreetopTreeHouse.new file }
        puts "Day  8, part A: #{ tree_grid.visible } trees are visible from outside the grid."
        puts "Day  8, part B: #{ tree_grid.scenic_score } is the highest scenic score possible for any tree."
        # puts "Day  6, part B: The message marker ends at character #{ datastream.message_marker }."
        puts
      end

      def initialize(file)
        @tree_lines = file.readlines(chomp: true).map(&:chars).map { |line| line.map(&:to_i) }
      end

      # Returns a list of directories in this directory, and the size of the files visible in this directory.
      def parse_dir(ary)
        ary.reduce([0]) { |acc, entry| pp entry, acc; entry.start_with?("dir ") ? acc << entry[4..] : acc[0] += entry.to_i; pp entry, acc; acc }
      end

      def self.count_visible(grid)
        visible = grid.map { |line| line.map { |tree| 0 } }

        4.times.with_index do |direction|
          grid.each_with_index do |line, i|
            visible[i][0] = 1
            tallest       = line[0]
            line.each_with_index { |tree, j|
              next if j.zero?
              next if tree <= tallest
              tallest       = tree
              visible[i][j] = 1
            }
          end

          case direction
            when 0, 2
              grid    = grid.map { |line| line.reverse }
              visible = visible.map { |line| line.reverse }
            when 1
              grid    = grid.transpose
              visible = visible.transpose
            else
              # type code here
          end
        end
        visible
      end

      def visible
        TreetopTreeHouse.count_visible(@tree_lines).map { |line| line.sum }.sum
      end

      def self.find_scenic_score(grid)
        highest_score   = 0
        grid_transposed = grid.transpose

        grid.each_with_index do |line, i|
          next if i.zero? || i == grid.length - 1

          line.each_with_index do |tree, j|
            next if j.zero? || j == line.length - 1

            right_neighbors = line[j + 1..]
            right_neighbors = [right_neighbors.take_while { |height| height < tree }.count + 1, right_neighbors.count].min
            left_neighbors  = line[...j].reverse
            left_neighbors  = [left_neighbors.take_while { |height| height < tree }.count + 1, left_neighbors.count].min
            up_neighbors    = grid_transposed[j][i + 1..]
            up_neighbors    = [up_neighbors.take_while { |height| height < tree }.count + 1, up_neighbors.count].min
            down_neighbors  = grid_transposed[j][...i].reverse
            down_neighbors  = [down_neighbors.take_while { |height| height < tree }.count + 1, down_neighbors.count].min

            # pp [right_neighbors, left_neighbors, up_neighbors, down_neighbors]
            # pp [highest_score, right_neighbors * left_neighbors * up_neighbors * down_neighbors]
            highest_score = [highest_score, right_neighbors * left_neighbors * up_neighbors * down_neighbors].max
          end
        end
        highest_score
      end

      def scenic_score
        TreetopTreeHouse.find_scenic_score(@tree_lines)
      end
    end
  end
end
