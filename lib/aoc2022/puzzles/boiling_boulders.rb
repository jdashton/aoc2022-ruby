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

      # Modules always have to have a description
      module PointExtensions
        def with(**kwargs)
          super(**kwargs, hash: Point.hash_of_coords(kwargs[:x] || x, kwargs[:y] || y, kwargs[:z] || z))
        end
      end

      AXES = %i[x y z].freeze
      OPS  = %i[- +].freeze

      # noinspection RubyConstantNamingConvention
      Point = Data.define(:hash) do
        prepend PointExtensions

        # def to_a = [x, y, z]

        def [](atr)
          case atr
            when :x then hash & 0b1
            when :y then
            when :z then
          end
        end
      end

      # You can't get away without describing each class.
      class Point
        class << self
          alias super_new new

          # Override `new` because we always want to pass in an Array of [x, y, z].
          def new(ary) = super_new(hash_of_coords(*ary))

          def hash_of_coords(x, y, z) = (x << 10) + (y << 5) + z
        end
      end

      def initialize(file)
        @points = []
        @cubes  = Set.new file.readlines(chomp: true).map(&method(:point_from_text))
      end

      def point_from_text(text_coords)
        @points << (text_coords_split_map = text_coords.split(',').map(&:to_i))
        Point.new(text_coords_split_map)
      end

      AXES_PRODUCT_OPS = AXES.product(OPS).freeze # [[:x, :-], [:x, :+], [:y, :-], [:y, :+], [:z, :-], [:z, :+]]

      def self.neighbors(cube)
        Set.new(AXES_PRODUCT_OPS.map { |(atr, op)| cube.with(atr => cube[atr].send(op, 1)) })
      end

      def count_faces = @cubes.reduce(0) { |acc, cube| acc + (BoilingBoulders.neighbors(cube) - @cubes).size }

      def remove_external_space(container, position)
        container -= (ns = (BoilingBoulders.neighbors(position) & container) - @cubes)
        ns.each { |cube| container = remove_external_space(container, cube) }
        container
      end

      def part_one
        count_faces
      end

      def part_two
        xs, ys, zs = BoilingBoulders.dimensions(@points)

        container = Set.new xs.product(ys, zs).map(&Point.method(:new))

        container.delete(position = Point.new([xs, ys, zs].map(&:first)))
        @cubes = remove_external_space(container, position)

        part_one
      end

      def self.dimensions(cubes_array)
        cubes_array.map(&:to_a).transpose.map(&:minmax).map { ((_1.first - 1)..(_1.last + 1)).to_a }
      end
    end
  end
end
