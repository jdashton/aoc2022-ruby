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

      Point = Data.define(:x, :y, :z, :hash)

      def Point.eql?(other)
        puts "Testing equality: #{ self } vs #{ other }"
        if x == other.x && y == other.y && z == other.z && id != other.id
          puts "Strange coincidence #{ self } vs #{ other }"
        end
        x == other.x && y == other.y && z == other.z
      end

      def gen_hash(x, y, z) = (x << 20) + (y << 10) + z

      # :reek:FeatureEnvy
      def initialize(file)
        @cubes = file.readlines(chomp: true).reduce(Set.new) do |acc, line|
          x, y, z = line.split(',').map(&:to_i)
          acc << Point.new(x, y, z, gen_hash(x, y, z))
        end
        # pp @cubes
      end

      def neighbors(cube)
        s = Set.new
        s << cube.with(x: cube.x - 1, hash: gen_hash(cube.x - 1, cube.y, cube.z))
        s << cube.with(x: cube.x + 1, hash: gen_hash(cube.x + 1, cube.y, cube.z))
        s << cube.with(y: cube.y - 1, hash: gen_hash(cube.x, cube.y - 1, cube.z))
        s << cube.with(y: cube.y + 1, hash: gen_hash(cube.x, cube.y + 1, cube.z))
        s << cube.with(z: cube.z - 1, hash: gen_hash(cube.x, cube.y, cube.z - 1))
        s << cube.with(z: cube.z + 1, hash: gen_hash(cube.x, cube.y, cube.z + 1))
      end

      def count_faces
        @cubes.reduce(0) { |acc, cube| acc + (neighbors(cube) - @cubes).size }
      end

      def remove_external_space(container, position)
        # print container.size
        ns        = (neighbors(position) & container) - @cubes
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
        xs, ys, zs = @cubes.to_a.map { [_1.x, _1.y, _1.z] }.transpose.map(&:minmax)
        # pp [xs, ys, zs]
        x_min = xs.first - 1
        y_min = ys.first - 1
        z_min = zs.first - 1
        ((z_min)..(zs.last + 1)).each do |z|
          ((y_min)..(ys.last + 1)).each do |y|
            ((x_min)..(xs.last + 1)).each do |x|
              container << Point.new(x, y, z, gen_hash(x, y, z))
            end
          end
        end

        position = Point.new(x_min, y_min, z_min, gen_hash(x_min, y_min, z_min))
        container.delete(position)
        @cubes = remove_external_space(container, position)
        # puts "Calling count_faces"
        count_faces
      end
    end
  end
end
