# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Resolves positions of scanners and probes
  class BeaconScanner
    extend Forwardable
    # def_instance_delegators "self.class", :y_step, :gauss

    # Encapsulates operations on probes seen by a scanner
    class Scanner
      attr_reader :id, :probes

      def initialize(lines)
        @id     = nil
        @probes = Set[]
        # Need a collection of distances associated with the two points between them.
        # Also need to have the distances as a Set that can be compared to the Set from another scanner.
        @distances = Set[]
        lines.each do |line|
          case line
            when /--- scanner (\d+) ---/
              @id = Regexp.last_match(1).to_i
            when /(-?\d+),(-?\d+),(-?\d+)/
              @probes << [Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3)].map(&:to_i)
          end
        end
        # puts "#{ @probes.size } probes in set #{ @id }. #{ @probes.to_a.combination(2).to_a.size } combinations"
        @probes.to_a.combination(2).each { |pb1, pb2| }
      end
    end

    def self.day19
      beacon_scanner = File.open("input/day19a.txt") { |file| BeaconScanner.new file }
      puts "Day 19, part A: #{ beacon_scanner.num_probes } unique probes visible to these scanners"
      # puts "Day 19, part B: #{snailfish.permutations} is the largest magnitude of any sum of two different snailfish numbers."
      puts
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

    def num_probes = 79

    def distance(pt1, pt2)
      # puts "Distance from #{ pt1 } to #{ pt2 }"
      delta_vector = [pt1[0] - pt2[0], pt1[1] - pt2[1], pt1[2] - pt2[2]]
      # pp delta_vector
      Math.sqrt((delta_vector[0]**2) + (delta_vector[1]**2) + (delta_vector[2]**2))
    end
  end
end
