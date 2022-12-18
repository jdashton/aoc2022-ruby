# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 8, we're looking at trees.
    class TreetopTreeHouse
      def self.day08
        tree_grid = File.open('input/day08.txt') { |file| TreetopTreeHouse.new file }
        puts "Day  8, Part One: #{ tree_grid.visible } trees are visible from outside the grid."
        puts "Day  8, Part Two: #{ tree_grid.scenic_score } is the highest scenic score possible for any tree."
        puts
      end

      def initialize(file)
        @tree_lines = file.readlines(chomp: true).map(&:chars).map { |line| line.map(&:to_i) }
      end

      def self.count_visible(grid)
        visible = grid.map { |line| line.map { 0 } }

        4.times do |direction|
          grid.each_with_index do |line, i|
            visible[i][0] = 1
            tallest       = line[0]
            line.each_with_index do |tree, j|
              next if j.zero?
              next if tree <= tallest

              tallest       = tree
              visible[i][j] = 1
            end
          end

          # noinspection RubyCaseWithoutElseBlockInspection
          case direction
            when 0, 2
              grid    = grid.map(&:reverse)
              visible = visible.map(&:reverse)
            when 1
              grid    = grid.transpose
              visible = visible.transpose
          end
        end
        visible
      end

      def visible
        TreetopTreeHouse.count_visible(@tree_lines).map(&:sum).sum
      end

      def self.find_scenic_score(grid)
        highest_score   = 0
        grid_transposed = grid.transpose

        grid.each_with_index do |line, i|
          next if i.zero? || i == grid.length - 1

          line.each_with_index do |tree, j|
            next if j.zero? || j == line.length - 1

            highest_score =
              [highest_score,
               count_neighbors(line[j + 1..], tree) *
                 count_neighbors(line[...j].reverse, tree) *
                 count_neighbors(grid_transposed[j][...i].reverse, tree) *
                 count_neighbors(grid_transposed[j][i + 1..], tree)].max
          end
        end
        highest_score
      end

      def self.count_neighbors(neighbors, tree)
        [neighbors.take_while { |height| height < tree }.count + 1, neighbors.count].min
      end

      def scenic_score
        TreetopTreeHouse.find_scenic_score(@tree_lines)
      end
    end
  end
end
