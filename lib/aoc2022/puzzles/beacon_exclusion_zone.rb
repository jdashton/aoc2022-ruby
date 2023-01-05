# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 15, we're looking for the missing beacon.
    class BeaconExclusionZone
      def self.day15
        beacon_exclusion_zone = File.open('input/day15.txt') { |file| BeaconExclusionZone.new file }
        puts "Day 15, Part One: #{ beacon_exclusion_zone.check_row(2_000_000) } positions cannot contain a beacon."
        # puts "Day 15, Part Two: #{ beacon_exclusion_zone.tuning_frequency(4_000_000) } is the tuning frequency."
        puts
      end

      def initialize(file)
        @sensors = file.readlines(chomp: true).map { |line| Sensor.new(line) }
      end

      # Each sensor knows its own X,Y and the X,Y of the nearest beacon.
      class Sensor
        attr_reader :sx, :sy, :bx, :by

        PAT = /\A\D*=(-?\d+)\D*=(-?\d+)\D*=(-?\d+)\D*=(-?\d+)\D*\z/

        def initialize(line)
          PAT =~ line
          @sx, @sy, @bx, @by = $~.captures.map(&:to_i)
        end

        def distance = (@sx - @bx).abs + (@sy - @by).abs

        def range_on_row(row)
          d = distance
          return if (@sy - row).abs > d

          reach = d - (@sy - row).abs
          (@sx - reach)..(@sx + reach)
        end

        def to_s
          "Sensor at x=#{ @sx }, y=#{ @sy }: closest beacon is at x=#{ @bx }, y=#{ @by }."
        end

        def inspect = to_s
      end

      def merge_ranges(ranges)
        rs = ranges.compact.sort_by(&:minmax)
        rs[1..].reduce([rs.first]) do |acc, r|
          # puts "Merging #{r} into #{acc}."
          merged = false
          acc    = acc.map do |r_acc|
            if r.min <= (r_acc.max + 1)
              merged = r_acc.min..[r_acc.max, r.max].max
            else
              r_acc
            end
          end
          merged ? acc : acc << r
        end
      end

      def insert_beacons(ranges, row)
        beacon = @sensors.find { |s| s.by == row }&.bx
        return ranges unless beacon

        ranges.reduce([]) do |acc, range|
          if range.member?(beacon)
            acc + [range.min..(beacon - 1), (beacon + 1)..range.max]
          else
            acc << range
          end
        end
      end

      def check_row(row)
        ranges = find_ranges(row)
        insert_beacons(ranges, row).map(&:count).sum
      end

      def find_ranges(row)
        ranges = @sensors.map { |s| s.range_on_row(row) }
        merge_ranges(ranges)
      end

      def tuning_frequency(max_coord)
        (0..max_coord).each do |i|
          rs = merge_ranges(find_ranges(i).map { |r| (r.begin.clamp(0..max_coord))..(r.end.clamp(0..max_coord)) })
          break ((rs.first.end + 1) * 4_000_000) + i if rs.length > 1
        end
      end
    end
  end
end
