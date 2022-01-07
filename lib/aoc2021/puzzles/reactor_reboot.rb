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

    STEP_PAT = /(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/

    attr_reader :cuboids

    def initialize(file = StringIO.new(""))
      @cuboids     = CuboidList.new
      @full_volume = @near_volume = 0
      file.readlines(chomp: true)
          .map { |line|
            md = STEP_PAT.match(line)
            Cuboid.new(md[1] == "on", *md.captures[1..].map(&:to_i))
          }
          .each(&method(:process_cuboid))
    end

    # def make_and_process(match_data)
    #   Cuboid.new(match_data[1] == "on", *match_data.captures[1..].map(&:to_i).each_slice(2).map { Range.new(*_1) })
    # end

    def process_cuboid(cuboid)
      # puts "Processing #{ cuboid }"
      new_cuboids = if cuboid.lit
                      @full_volume += cuboid.volume
                      @near_volume += cuboid.near_volume
                      [cuboid]
                    else
                      []
                    end

      @cuboids.each do |oc|
        next unless cuboid.intersects?(oc.x1, oc.x2, oc.y1, oc.y2, oc.z1, oc.z2)

        cuboid_intersection = oc.intersection(cuboid)
        # puts "  ..  Intersects with #{ other_cuboid }, adding #{ cuboid_intersection }"

        @full_volume += cuboid_intersection.volume
        @near_volume += cuboid_intersection.near_volume
        new_cuboids.push(cuboid_intersection)
      end
      @cuboids.insert(new_cuboids)
      # puts "Total volume of #{ @full_volume }."
      # puts
    end

    # Encapsulates operations on a list of cuboids
    class CuboidList
      extend Forwardable
      def_instance_delegators :@list, :each

      def initialize
        @list = []
      end

      def insert(other) = @list += other

      def to_s = "CuboidList#{ @list }"

      def inspect = "CuboidList#{ @list.inspect }"
    end

    # Encapsulates operations on a cube
    class Cuboid
      attr_reader :lit, :x1, :x2, :y1, :y2, :z1, :z2

      def initialize(lit, x1, x2, y1, y2, z1, z2)
        @lit    = lit
        @x1     = x1
        @x2     = x2
        @y1     = y1
        @y2     = y2
        @z1     = z1
        @z2     = z2
        @volume = (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
      end

      NEAR_SPACE = [-50, 50] * 3

      def to_s = "Cuboid[ lit: #{ @lit }, #{ @x1 }, #{ @x2 }, #{ @y1 }, #{ @y2 }, #{ @z1 }, #{ @z2 } ]"

      def volume = @lit ? @volume : (0 - @volume)

      def near_volume = intersects?(*NEAR_SPACE) ? volume : 0

      def intersects?(x1, x2, y1, y2, z1, z2)
        # max_x, max_y, max_z = [max(box_a[i], box_b[i]) for i in (0, 2, 4)]
        # min_xp, min_yp, min_zp = [min(box_a[i], box_b[i]) for i in (1, 3, 5)]
        # if min_xp - max_x >= 0 and min_yp - max_y >= 0 and min_zp - max_z >= 0:
        #   return max_x, min_xp, max_y,  min_yp, max_z, min_zp

        @z1 <= z2 && @z2 >= z1 &&
          @y1 <= y2 && @y2 >= y1 &&
          @x1 <= x2 && @x2 >= x1
      end

      def intersection(other)
        Cuboid.new(!@lit, *make_x_range(other), *make_y_range(other), *make_z_range(other))
      end

      private

      def make_x_range(other)
        [[@x1, other.x1].max, [@x2, other.x2].min]
      end

      def make_y_range(other)
        [[@y1, other.y1].max, [@y2, other.y2].min]
      end

      def make_z_range(other)
        [[@z1, other.z1].max, [@z2, other.z2].min]
      end
    end

    def cube_volume = @near_volume

    def cube_volume_unlimited = @full_volume

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
