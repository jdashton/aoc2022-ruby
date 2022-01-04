# frozen_string_literal: true

require "forwardable"
require "matrix"

module AoC2021
  # Resolves positions of scanners and probes
  class BeaconScanner
    def self.day19
      beacon_scanner = File.open("input/day19a.txt") { |file| BeaconScanner.new file }
      beacon_scanner.merge_all
      puts "Day 19, part A: #{ beacon_scanner.num_beacons } unique probes visible to these scanners"
      puts "Day 19, part B: #{ beacon_scanner.largest_distance } is the largest Manhattan distance between any two scanners."
      # puts "Day 19, part B: #{snailfish.permutations} is the largest magnitude of any sum of two different snailfish numbers."
      puts
    end

    # Encapsulates operations on probes seen by a scanner
    class Scanner
      attr_reader :id, :beacons, :distances, :pairs, :translation

      def initialize(lines)
        @id      = nil
        @beacons = Set[]
        # Need a collection of distances associated with the two points between them.
        # Also need to have the distances as a Set that can be compared to the Set from another scanner.
        @distances = Set[]
        lines.each do |line|
          case line
            when /--- scanner (\d+) ---/
              @id = Regexp.last_match(1).to_i
            when /(-?\d+),(-?\d+),(-?\d+)/
              @beacons << Beacon.new(*[Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3)].map(&:to_i))
          end
        end
        # puts "#{ @probes.size } probes in set #{ @id }. #{ @probes.to_a.combination(2).to_a.size } combinations"
        @pairs = {}
        @beacons.to_a.combination(2).each do |bcn1, bcn2|
          s_m_distance = bcn1.sorted_manhattan_distance(bcn2)
          @distances << s_m_distance
          @pairs[s_m_distance] = [bcn1, bcn2]
        end
        @intersections = {}
        @translation   = Vector.zero(3)
      end

      def merge(other)
        rot, trans = other.triangulate(self)
        @beacons   += other.beacons.map { _1.rectify(rot, trans) }
        @distances += other.distances
        @pairs.merge!(other.pairs.transform_values { |pair| pair.map { _1.rectify(rot, trans) } })
        @intersections = {}
      end

      def common(other)
        intersections(other).size >= 66
      end

      # Returns a Set of the beacons that are common to this scanner
      # and other scanner, in the coordinate system of this scanner.
      def common_beacons(other)
        intersections(other).reduce(Set[]) do |acc, int|
          # pairs << @pairs[int]
          acc + [*@pairs[int]]
        end
      end

      ROTATIONS = [
        Matrix[[1, 0, 0], [0, 1, 0], [0, 0, 1]],
        Matrix[[1, 0, 0], [0, 0, -1], [0, 1, 0]],
        Matrix[[1, 0, 0], [0, -1, 0], [0, 0, -1]],
        Matrix[[1, 0, 0], [0, 0, 1], [0, -1, 0]],

        Matrix[[0, 1, 0], [-1, 0, 0], [0, 0, 1]],
        Matrix[[0, 1, 0], [0, 0, -1], [-1, 0, 0]],
        Matrix[[0, 1, 0], [1, 0, 0], [0, 0, -1]],
        Matrix[[0, 1, 0], [0, 0, 1], [1, 0, 0]],

        Matrix[[0, 0, 1], [0, 1, 0], [-1, 0, 0]],
        Matrix[[0, 0, 1], [1, 0, 0], [0, 1, 0]],
        Matrix[[0, 0, 1], [0, -1, 0], [1, 0, 0]],
        Matrix[[0, 0, 1], [-1, 0, 0], [0, -1, 0]],

        Matrix[[-1, 0, 0], [0, 1, 0], [0, 0, -1]],
        Matrix[[-1, 0, 0], [0, 0, -1], [0, -1, 0]],
        Matrix[[-1, 0, 0], [0, -1, 0], [0, 0, 1]],
        Matrix[[-1, 0, 0], [0, 0, 1], [0, 1, 0]],

        Matrix[[0, -1, 0], [1, 0, 0], [0, 0, 1]],
        Matrix[[0, -1, 0], [0, 0, -1], [1, 0, 0]],
        Matrix[[0, -1, 0], [-1, 0, 0], [0, 0, -1]],
        Matrix[[0, -1, 0], [0, 0, 1], [-1, 0, 0]],

        Matrix[[0, 0, -1], [0, 1, 0], [1, 0, 0]],
        Matrix[[0, 0, -1], [1, 0, 0], [0, -1, 0]],
        Matrix[[0, 0, -1], [0, -1, 0], [-1, 0, 0]],
        Matrix[[0, 0, -1], [-1, 0, 0], [0, 1, 0]]
      ].freeze

      # Returns a pair of Beacon objects (points) that have the given s_m_distance
      # with coordinates in the coordinate system of this scanner. This is an accessor
      # that allows Scanner 1 (for example) to ask Scanner 0 for its beacons that match
      # the given distance.
      def pair(distance)
        @pairs[distance]
      end

      def check_all_twelve(rot, translation, common_beacons, other_common_beacons)
        Set[*other_common_beacons.map(&:to_v)] == Set[*common_beacons.map { |beacon| (rot * beacon.to_v) + translation }]
      end

      def triangulate(other)
        beacons = common_beacons(other)

        # pp ints
        distance = intersections(other).to_a.first
        puts "Starting with distance #{ distance }"
        beacon_a, beacon_b = @pairs[distance]
        puts "Beacons at this distance: #{ beacon_a }, #{ beacon_b }"
        other_a, other_b = other.pair(distance)
        puts "Beacons from other scanner at this distance: #{ other_a }, #{ other_b }"

        vector_a = beacon_a.to_v
        vector_b = beacon_b.to_v

        translation = nil

        rotation     = ROTATIONS.find do |rot|
          translation = other_b.to_v - (rot * vector_a)
          if (rot * vector_b) + translation == other_a.to_v
            puts "We found one with rotation #{ rot } and translation #{ translation }"
            if check_all_twelve(rot, translation, beacons, other.common_beacons(self))
              puts "All 12 match!"
              next true
            else
              puts " --- Found some matches, but not 12 --- "
            end
          end

          translation = other_a.to_v - (rot * vector_a)
          if (rot * vector_b) + translation == other_b.to_v
            puts "We found one with rotation #{ rot } and translation #{ translation }"
            if check_all_twelve(rot, translation, beacons, other.common_beacons(self))
              puts "All 12 match!"
              next true
            else
              puts " --- Found some matches, but not 12 --- "
            end
          end
          false
        end
        @translation = translation
        [rotation, translation]
      end

      private

      def intersections(other)
        @intersections[other] ||= @distances & other.distances
      end
    end

    # Encapsulates operations on points
    class Beacon
      attr_reader :x, :y, :z

      def initialize(x, y, z)
        @x = x
        @y = y
        @z = z
      end

      def sorted_manhattan_distance(other_point)
        # puts "Distance from #{ pt1 } to #{ pt2 }"
        # delta_vector =
        [(@x - other_point.x).abs, (@y - other_point.y).abs, (@z - other_point.z).abs].sort
        # pp delta_vector
        # Math.sqrt((delta_vector[0]**2) + (delta_vector[1]**2) + (delta_vector[2]**2))
      end

      def rectify(rot, trans)
        Beacon.new(*((rot * to_v) + trans).to_a)
      end

      def to_v
        Vector[@x, @y, @z]
      end

      def hash
        [@x, @y, @z].hash
      end

      def eql?(other)
        @x == other.x && @y == other.y && @z == other.z
      end

      def to_s
        "Beacon: #{ @x }, #{ @y }, #{ @z }"
      end

      def inspect = to_s
    end

    attr_reader :scanners

    def initialize(file = StringIO.new(""))
      @lines    = file.readlines(chomp: true)
      @scanners = []
      index     = 0
      until index >= @lines.size
        next_blank = @lines[index..].index(&:empty?) || @lines.size
        scanner    = Scanner.new(@lines[index..index + next_blank])
        @scanners << scanner
        index += next_blank + 1
      end
      # pp @scanners
    end

    def num_beacons = full_map.size

    def full_map = @scanners.first.beacons

    def merge_all
      unprocessed = @scanners[1..]
      main        = @scanners.first
      while unprocessed.size.positive?
        some_scanner = unprocessed.sample
        if main.common(some_scanner)
          main.merge(some_scanner)
          unprocessed.delete(some_scanner)
        end
      end
    end

    def largest_distance
      @scanners.combination(2).map { |scn1, scn2| (scn1.translation - scn2.translation).to_a.sum.abs }.max
    end
  end
end
