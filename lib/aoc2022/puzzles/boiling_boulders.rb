# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 18, we're counting cubes' surfaces.
    class BoilingBoulders
      def self.day18
        boiling_boulders = File.open('input/day18.txt') { |file| BoilingBoulders.new file }
        puts "Day 18, Part One: #{ boiling_boulders.part_one } is the number of faces."
        puts "Day 18, Part Two: #{ boiling_boulders.part_two } is the number of external faces."
        puts
      end

      # :reek:FeatureEnvy
      def initialize(file)
        @cubes = file.readlines(chomp: true).reduce(Set.new) { |acc, line| acc << line.split(',').map(&:to_i) }
        # pp @cubes
      end

      def neighbors(cube)
        s = Set.new
        s << [cube[0] - 1, cube[1], cube[2]]
        s << [cube[0] + 1, cube[1], cube[2]]
        s << [cube[0], cube[1] - 1, cube[2]]
        s << [cube[0], cube[1] + 1, cube[2]]
        s << [cube[0], cube[1], cube[2] - 1]
        s << [cube[0], cube[1], cube[2] + 1]
      end

      def count_faces
        @cubes.reduce(0) { |acc, cube| acc + (neighbors(cube) - @cubes).size }
      end

      def remove_external_space(container, position)
        # print container.size
        ns = neighbors(position) & container - @cubes
        container -= ns
        ns.each do |cube|
          # pp cube
          container = remove_external_space(container, cube)
        end
        # puts " -- #{container.size}"
        container
      end

      def part_one
        count_faces
      end

      def part_two
        container  = Set.new
        xs, ys, zs = @cubes.to_a.transpose.map(&:minmax)
        ((zs.first - 1)..(zs.last + 1)).each do |z|
          ((ys.first - 1)..(ys.last + 1)).each do |y|
            ((xs.first - 1)..(xs.last + 1)).each do |x|
              container << [x, y, z]
            end
          end
        end

        position = [xs.first - 1, ys.first - 1, zs.first - 1]
        container.delete(position)
        @cubes = remove_external_space(container, position)
        # puts "Calling count_faces"
        count_faces
      end
    end
  end
end
