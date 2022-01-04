# frozen_string_literal: true

require "forwardable"
require "matrix"

module AoC2021
  # Resolves positions of scanners and probes
  class BeaconScanner
    def self.day19
      beacon_scanner = File.open("input/day19a.txt") { |file| BeaconScanner.new file }.merge_all
      puts "Day 19, part A: #{ beacon_scanner.num_beacons } unique beacons visible to these scanners"
      puts "Day 19, part B: #{ beacon_scanner.largest_distance } is the largest Manhattan distance between any two scanners."
      puts
    end

    # Encapsulates operations on probes seen by a scanner
    class Scanner
      attr_reader :distances

      NUMS = /(-?\d+),(-?\d+),(-?\d+)/

      def initialize(lines)
        @beacons        = lines.reduce(Set[]) { |acc, line| NUMS.match(line) { |md| match_beacon acc, md } || acc }
        @pairs          = @beacons.to_a.combination(2).reduce([], &method(:distance_and_pair)).to_h
        @distances      = Set[*@pairs.keys]
        @intersections  = {}
        @common_beacons = {}
        @rotation       = @translation = nil # Matrix.diagonal(1, 1, 1), Vector.zero(3)
      end

      def translation_data = [@rotation, @translation]

      def beacons = @rotation && @translation ? @beacons.map(&method(:translate)) : @beacons

      def pairs = @rotation && @translation ? @pairs.transform_values { |pair| pair.map { translate(_1) } } : @pairs

      def translation = @translation || Vector.zero(3)

      def merge(other)
        other.triangulate(self)
        @beacons   += other.beacons
        @distances += other.distances
        @pairs.merge!(other.pairs)
        @intersections = {}
      end

      def common(other)
        intersections(other).size >= 66
      end

      # Returns a Set of the beacons that are common to this scanner
      # and other scanner, in the coordinate system of this scanner.
      def common_beacons(other)
        @common_beacons[other] ||=
          intersections(other).reduce(Set[]) do |acc, int|
            acc + @pairs[int]
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

      def check_all_common_beacons(rot, translation, other)
        common_beacons       = self.common_beacons(other)
        other_common_beacons = other.common_beacons(self)
        Set[*other_common_beacons] == Set[*common_beacons.map { |beacon| (rot * beacon) + translation }]
      end

      def triangulate(other)
        distance           = intersections(other).first
        beacon_a, beacon_b = @pairs[distance]
        other_pair         = other.pair(distance).permutation(2)

        @rotation = ROTATIONS.find do |rot|
          other_pair.any? do |other_a, other_b|
            trans = other_b - (rot * beacon_a)
            (rot * beacon_b) + trans == other_a && check_all_common_beacons(rot, (@translation = trans), other)
          end
        end
        @rotation && @translation
      end

      private

      def translate(beacon)
        beacon.rectify(@rotation, @translation)
      end

      def match_beacon(acc, md)
        acc << Beacon[*md.captures.map(&:to_i)]
      end

      def distance_and_pair(acc, (bcn1, bcn2))
        acc << [bcn1.distance(bcn2), [bcn1, bcn2]]
      end

      def intersections(other)
        @intersections[other] ||= @distances & other.distances
      end
    end

    # Encapsulates operations on points
    class Beacon < Vector
      def distance(other_point) = (self - other_point).to_a.map(&:abs).sort

      def rectify(rot, trans) = Beacon[*((rot * self) + trans).to_a]

      def to_s = "Beacon[#{ to_a.join(", ") }]"

      def inspect = "Beacon#{ @elements.inspect }"
    end

    attr_reader :scanners, :primary

    def initialize(file = StringIO.new(""))
      @scanners = file.readlines(chomp: true)
                      .chunk_while { |line, _| !line.empty? }
                      .reduce([]) { |acc, block| acc << Scanner.new(block) }
      @merged   = [@primary = @scanners.shift]
    end

    def num_beacons = full_map.size

    def full_map = @primary&.beacons

    def merge_all
      until @scanners.empty?
        some_scanner = @scanners.sample
        if @primary&.common(some_scanner)
          @primary&.merge(some_scanner)
          @merged << @scanners.delete(some_scanner)
        end
      end
      self
    end

    def largest_distance
      @merged.combination(2).map { |scn1, scn2| (scn1.translation - scn2.translation).to_a.sum.abs }.max
    end
  end
end
