# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Rebooting cubes in the reactor for Day 22
  class ReactorReboot
    def self.day22
      reactor_reboot = File.open("input/day22a.txt") { |file| ReactorReboot.new file }
      puts "Day 22, part A: #{ reactor_reboot.cube_volume } cubes are on within the -50..50 space."
      puts "Day 22, part B: #{ reactor_reboot.cube_volume_unlimited } cubes are on."
      puts
    end

    extend Forwardable
    def_instance_delegators :@cuboids, :cube_volume, :cube_volume_unlimited

    attr_reader :cuboids

    STEP_PAT = /(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/

    def initialize(file = StringIO.new(""))
      @cuboids = CuboidList.new(
        file.readlines(chomp: true)
            .map { |line|
              md = STEP_PAT.match(line)
              Cuboid.new(md[1] == "on", md.captures[1..].map(&:to_i))
            }
            .reverse)
      @cuboids.each { |cuboid| @cuboids.process_cuboid(cuboid) }
    end

    # Encapsulates operations on a list of cuboids
    class CuboidList
      extend Forwardable
      def_instance_delegators :@initial_list, :each
      def_instance_delegators :@counted, :<<

      attr_reader :full_volume, :near_volume

      def initialize(list)
        @initial_list = list
        @counted      = []
        @full_volume  = @near_volume = 0
      end

      def insert(other) = @initial_list += other

      def process_cuboid(cuboid)
        # puts "Processing #{ cuboid }"
        if cuboid.lit
          @full_volume += cuboid.volume
          @near_volume += cuboid.near_volume
          # puts "Total volume now #{ @full_volume }."

          dead_list = []

          @counted.each { |oc| dead_list << cuboid.intersects?(oc.coords) }

          dead_list = CuboidList.new(dead_list.compact)
          dead_list.each { dead_list.process_cuboid(_1) }

          @full_volume -= dead_list.full_volume
          @near_volume -= dead_list.near_volume
        end
        @counted << cuboid
        # puts "Total volume of #{ @full_volume }."
        # puts
      end

      def cube_volume = @near_volume

      def cube_volume_unlimited = @full_volume

      def to_s = "CuboidList#{ @initial_list }"

      def inspect = "CuboidList#{ @initial_list.inspect }"
    end

    # Encapsulates operations on a cube
    class Cuboid
      attr_reader :lit, :coords

      def initialize(lit, coords)
        @lit    = lit
        @coords = coords
        @volume = (@coords[1] - @coords[0] + 1) * (@coords[3] - @coords[2] + 1) * (@coords[5] - @coords[4] + 1)
      end

      NEAR_SPACE = [-50, 50] * 3

      def to_s = "Cuboid[ lit: #{ @lit }, #{ @coords } ]"

      def volume = @lit ? @volume : @volume

      def near_volume = intersects?(NEAR_SPACE) ? volume : 0

      def intersects?(coords)
        # max_x, max_y, max_z = [max(box_a[i], box_b[i]) for i in (0, 2, 4)]
        # min_xp, min_yp, min_zp = [min(box_a[i], box_b[i]) for i in (1, 3, 5)]
        # if min_xp - max_x >= 0 and min_yp - max_y >= 0 and min_zp - max_z >= 0:
        #   return max_x, min_xp, max_y,  min_yp, max_z, min_zp

        max_x_left   = [@coords[0], coords[0]].max
        min_x_right  = [@coords[1], coords[1]].min
        max_y_bottom = [@coords[2], coords[2]].max
        min_y_top    = [@coords[3], coords[3]].min
        max_z_front  = [@coords[4], coords[4]].max
        min_z_back   = [@coords[5], coords[5]].min

        (max_x_left <= min_x_right && max_y_bottom <= min_y_top && max_z_front <= min_z_back &&
          Cuboid.new(true, [max_x_left, min_x_right, max_y_bottom, min_y_top, max_z_front, min_z_back])) || nil
      end
    end

    # def process_one_cube(new_cube)
    #   potential = [new_cube]
    #   # @cubes.each do |cube|
    #   @cuboids[(@cuboids.bsearch_index { _1[1].end >= new_cube[1].begin })..].each do |cube|
    #     potential = detect_and_split(potential, cube)
    #   end
    #   @cuboids.insert(@cuboids.bsearch_index { _1[1].end > new_cube[1].end } || @cuboids.size, *potential)
    #   @cuboids.sort_by! { _1[1].end }
    # end
  end
end
