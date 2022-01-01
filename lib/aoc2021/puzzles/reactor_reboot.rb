# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Rebooting cubes in the reactor for Day 22
  class ReactorReboot
    def self.day22
      reactor_reboot = File.open("input/day22a.txt") { |file| ReactorReboot.new file }
      puts "Day 22, part A: #{ reactor_reboot.count_true } cubes are on."
      # puts "Day 22, part B: #{ reactor_reboot.process_volumes } cubes are on."
      puts
    end

    STEP_PAT = /(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/

    def initialize(file = StringIO.new(""))
      @raw_steps = []
      @steps     = file.readlines(chomp: true).map { |line| STEP_PAT.match(line, &method(:make_step)) }
      @cubes     = []
      @space     = []
      @steps.each(&method(:run_step))
    end

    def process_volumes
      # puts "raw_steps:"
      # pp @raw_steps.reverse
      # puts

      @raw_steps.reverse.each(&method(:process_one_cube))
      cube_volume
    end

    def count_true = @space.flatten.count(:on)

    def self.rectify(int) = [[int + 50, 0].max, 100].min

    def self.make_range((start, stop))
      return 2..1 if stop < -50 || start > 50

      Range.new(rectify(start), rectify(stop))
    end

    def self.make_raw_range((start, stop))
      Range.new(start, stop)
    end

    def make_step(match_data)
      range_data = match_data.captures[1..].map(&:to_i).each_slice(2)
      @raw_steps << [match_data[1].to_sym, *range_data.map(&self.class.method(:make_raw_range))]
      [match_data[1].to_sym, *range_data.map(&self.class.method(:make_range))]
    end

    def self.mark_row(page, row_num, step) = step[1].each { |col| (page[row_num] ||= [])[col] = step[0] }

    private

    def cube_volume
      @cubes.reduce(0) do |acc, (state, x_range, y_range, z_range)|
        next acc if state == :off

        acc + ((x_range.end - x_range.begin + 1) * (y_range.end - y_range.begin + 1) * (z_range.end - z_range.begin + 1))
      end
    end

    def self.overlaps?((_c1state, c1x, c1y, c1z), (_c2state, c2x, c2y, c2z))
      # puts "#{ [c1x, c1y, c1z] }, #{ [c2x, c2y, c2z] }"
      (c1x.cover?(c2x.begin) || c1x.cover?(c2x.end) || c2x.cover?(c1x.begin) || c2x.cover?(c1x.end)) &&
        (c1y.cover?(c2y.begin) || c1y.cover?(c2y.end) || c2y.cover?(c1y.begin) || c2y.cover?(c1y.end)) &&
        (c1z.cover?(c2z.begin) || c1z.cover?(c2z.end) || c2z.cover?(c1z.begin) || c2z.cover?(c1z.end))
      # Set[*c1x].intersect?(Set[*c2x]) && Set[*c1y].intersect?(Set[*c2y]) && Set[*c1z].intersect?(Set[*c2z])
    end

    def self.split((c1s, c1x, c1y, c1z), (_, c2x, c2y, c2z))
      # puts "Need to split #{ cube1 } around #{ cube2 }"
      acc = []
      if c1x.begin < c2x.begin
        acc << [c1s, c1x.begin..(c2x.begin - 1), c1y, c1z]
        c1x = c2x.begin..c1x.end
      end
      if c1x.end > c2x.end
        acc << [c1s, (c2x.end + 1)..c1x.end, c1y, c1z]
        c1x = c1x.begin..c2x.end
      end
      if c1y.begin < c2y.begin
        acc << [c1s, c1x, c1y.begin..(c2y.begin - 1), c1z]
        c1y = c2y.begin..c1y.end
      end
      if c1y.end > c2y.end
        acc << [c1s, c1x, (c2y.end + 1)..c1y.end, c1z]
        c1y = c1y.begin..c2y.end
      end
      acc << [c1s, c1x, c1y, c1z.begin..(c2z.begin - 1)] if c1z.begin < c2z.begin
      acc << [c1s, c1x, c1y, (c2z.end + 1)..c1z.end] if c1z.end > c2z.end
      acc
    end

    def detect_and_split(potential, cube)
      potential.reduce([]) do |acc, pcube|
        if self.class.overlaps?(pcube, cube)
          acc + self.class.split(pcube, cube)
        else
          acc << pcube
        end
      end
    end

    def process_one_cube(new_cube)
      # puts " .. Processing #{ new_cube }"

      potential = [new_cube]
      @cubes.each do |cube|
        potential = detect_and_split(potential, cube)
      end
      @cubes += potential

      # print "Cubes: "
      # pp @cubes
      # puts
    end

    def run_step(step) = step[3].each { |page_num| mark_page page_num, step }

    def mark_page(page_num, step) = step[2].each { |row_num| self.class.mark_row (@space[page_num] ||= []), row_num, step }
  end
end
