# frozen_string_literal: true

require 'forwardable'

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

      extend Forwardable
      def_instance_delegators 'self.class', :neighbors, :dimensions

      # Modules always have to have a description
      module PointExtensions
        def with(**kwargs)
          super(**kwargs, hash: Point.hash_of_coords(kwargs[:x] || x, kwargs[:y] || y, kwargs[:z] || z))
        end
      end

      AXES = %i[x y z].freeze
      OPS  = %i[- +].freeze
      # noinspection RubyConstantNamingConvention
      Point = Data.define(*AXES, :hash) do
        prepend PointExtensions

        def to_a = [x, y, z]
      end

      # You can't get away without describing each class.
      class Point
        def self.hash_of_coords(x, y, z) = (x << 10) + (y << 5) + z

        def self.new_from_array(ary) = new(*ary, hash_of_coords(*ary))
      end

      # :reek:FeatureEnvy
      def initialize(file)
        @cubes = Set.new file.readlines(chomp: true).map { Point.new_from_array(_1.split(',').map(&:to_i)) }
      end

      def self.neighbors(cube)
        # [[:x, :-], [:x, :+], [:y, :-], [:y, :+], [:z, :-], [:z, :+]]
        Set.new(AXES.product(OPS).map { |(attr, op)| cube.with(attr => cube.send(attr).send(op, 1)) })
      end

      def count_faces = @cubes.reduce(0) { |acc, cube| acc + (neighbors(cube) - @cubes).size }

      def remove_external_space(container, position)
        # print container.size

        container -= (ns = (neighbors(position) & container) - @cubes)
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
        xs, ys, zs = dimensions(@cubes.to_a)

        container = Set.new xs.product(ys, zs).map { Point.new_from_array(_1) }

        container.delete(position = Point.new_from_array([xs, ys, zs].map(&:first)))
        @cubes = remove_external_space(container, position)

        count_faces
      end

      def self.dimensions(cubes_array)
        cubes_array.map(&:to_a).transpose.map(&:minmax).map { ((_1.first - 1)..(_1.last + 1)).to_a }
      end
    end
  end
end
