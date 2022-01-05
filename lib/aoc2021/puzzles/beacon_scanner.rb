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
      attr_reader :translation_data

      def initialize(lines)
        @beacons = lines.reduce(Set[]) { |acc, line| (new_beacon = Beacon.from_text(line)) ? (acc << new_beacon) : acc }
        @pairs   = make_pairs
        # @distances = Set[*@pairs.keys]
        @cache            = { all_distances: Set[*@pairs.keys], common_distances: {}, common_beacons: {} }
        @translation_data = nil # Matrix.diagonal(1, 1, 1), Vector.zero(3)
      end

      def beacons = @translation_data ? @beacons.map { _1.rectify(@translation_data) } : @beacons

      def pairs = @translation_data ? @pairs.transform_values { |pair| pair.map { _1.rectify(@translation_data) } } : @pairs

      # Returns a pair of Beacon objects (points) that have the given s_m_distance
      # with coordinates in the coordinate system of this scanner. This is an accessor
      # that allows Scanner 1 (for example) to ask Scanner 0 for its beacons that match
      # the given distance.
      def pair(distance) = @pairs[distance]

      def distances = @cache[:all_distances] ||= Set[*@pairs.keys]

      def translation = @translation_data&.last || Vector.zero(3)

      # Returns a Set of the beacons that are common to this scanner
      # and other scanner, in the coordinate system of this scanner.
      def common_beacons(other) = @cache[:common_beacons][other] ||= Set[*common_distances(other).flat_map { pair(_1) }]

      def common_distances(other) = @cache[:common_distances][other] ||= distances & other.distances

      def enough_common_distances(other) = common_distances(other).size >= 66

      def merge(other)
        other.triangulate(self)
        @beacons += other.beacons
        @pairs.merge!(other.pairs)
        @cache[:all_distances]    += other.distances
        @cache[:common_distances] = {}
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

      def triangulate(scanner_zero)
        beacon_pair = BeaconPairPairing.new(
          pair(distance = common_distances(scanner_zero).first),
          scanner_zero.pair(distance).permutation(2),
          Triangulator.new(self, scanner_zero)
        )

        @translation_data = [ROTATIONS.find { |rotation| beacon_pair.try_rotation(rotation) }, beacon_pair.translation]
      end

      # Encapsulates alignment operations
      class Triangulator
        def initialize(scanner, primary)
          @other_common_beacons = primary.common_beacons(scanner)
          @common_beacons_other = scanner.common_beacons(primary)
        end

        def aligns?(rotation, translation)
          @other_common_beacons == Set[*@common_beacons_other.map { (rotation * _1) + translation }]
        end
      end

      # Encapsulates operations on a pair of local and pair of remote beacons
      class BeaconPairPairing
        attr_reader :translation

        def initialize(local_pair, remote_permutations, triangulator)
          @local_pair               = local_pair
          @remote_pair_permutations = remote_permutations
          @triangulator             = triangulator
          @translation              = nil
        end

        def try_rotation(rotation)
          a_rotated, b_rotated = @local_pair.map { rotation * _1 }
          @remote_pair_permutations.any? do |oth_a, oth_b|
            (@translation = oth_b - a_rotated) &&
              b_rotated + @translation == oth_a &&
              @triangulator.aligns?(rotation, @translation)
          end
        end
      end

      private

      def make_pairs
        @beacons.to_a
                .combination(2)
                .reduce([]) { |acc, (bcn_a, bcn_b)| acc << [bcn_a.distance(bcn_b), [bcn_a, bcn_b]] }.to_h
      end
    end

    # Encapsulates operations on points
    class Beacon < Vector
      BEACON_LINE = /(-?\d+),(-?\d+),(-?\d+)/

      def self.from_text(line) = BEACON_LINE.match(line) { |match_data| Beacon[*match_data.captures.map(&:to_i)] }

      def distance(other) = (self - other).to_a.map(&:abs).sort

      def rectify((rot, trans)) = Beacon[*((rot * self) + trans).to_a]

      def to_s = "Beacon[#{ to_a.join(", ") }]"

      def inspect = "Beacon#{ self[0..].inspect }"
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
        if @primary&.enough_common_distances(some_scanner)
          @primary&.merge(some_scanner)
          @merged << @scanners.delete(some_scanner)
        end
      end
      self
    end

    def largest_distance
      @merged.combination(2).map { |scanner_a, scanner_b| (scanner_a.translation - scanner_b.translation).to_a.sum.abs }.max
    end
  end
end
