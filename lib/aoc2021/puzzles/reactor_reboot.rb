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
            Cuboid.new(md[1] == "on", *md.captures[1..].map(&:to_i).each_slice(2).map { Range.new(*_1) })
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

      @cuboids.each do |other_cuboid|
        next unless cuboid.intersects? other_cuboid

        cuboid_intersection = other_cuboid.intersection(cuboid)
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
      attr_reader :lit, :x_range, :y_range, :z_range

      def initialize(lit, x_range, y_range, z_range)
        @lit     = lit
        @x_range = x_range
        @y_range = y_range
        @z_range = z_range
        @volume  = @x_range.size * @y_range.size * @z_range.size
      end

      NEAR_SPACE = Cuboid.new(false, -50..50, -50..50, -50..50)

      def to_s = "Cuboid[ lit: #{ @lit }, #{ @x_range }, #{ @y_range }, #{ @z_range } ]"

      def volume = @lit ? @volume : (0 - @volume)

      def near_volume = intersects?(NEAR_SPACE) ? volume : 0

      def intersects?(other)
        @z_range.begin <= other.z_range.end && @z_range.end >= other.z_range.begin &&
          @y_range.begin <= other.y_range.end && @y_range.end >= other.y_range.begin &&
          @x_range.begin <= other.x_range.end && @x_range.end >= other.x_range.begin
      end

      def intersection(other)
        Cuboid.new(!@lit, make_x_range(other.x_range), make_y_range(other.y_range), make_z_range(other.z_range))
      end

      private

      def make_x_range(x_range)
        [@x_range.begin, x_range.begin].max..[@x_range.end, x_range.end].min
      end

      def make_y_range(y_range)
        [@y_range.begin, y_range.begin].max..[@y_range.end, y_range.end].min
      end

      def make_z_range(z_range)
        [@z_range.begin, z_range.begin].max..[@z_range.end, z_range.end].min
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
