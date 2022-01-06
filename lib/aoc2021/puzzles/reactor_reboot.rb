# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Rebooting cubes in the reactor for Day 22
  class ReactorReboot
    def self.day22
      reactor_reboot = File.open("input/day22a.txt") { |file| ReactorReboot.new file }.process_volumes
      puts "Day 22, part A: #{ reactor_reboot.cube_volume(-50..50) } cubes are on within the -50..50 space."
      puts "Day 22, part B: #{ reactor_reboot.cube_volume_unlimited } cubes are on."
      puts
    end

    STEP_PAT = /(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/

    def initialize(file = StringIO.new(""))
      @raw_steps = file.readlines(chomp: true).map { |line| STEP_PAT.match(line, &method(:make_step)) }
      @cubes     = nil
    end

    def make_step(match_data)
      [match_data[1].to_sym, *match_data.captures[1..].map(&:to_i).each_slice(2).map { Range.new(*_1) }]
    end

    def process_volumes
      @cubes = [@raw_steps.pop]
      @raw_steps.reverse.each(&method(:process_one_cube))
      self
    end

    def cube_volume_unlimited
      @cubes.reduce(0) do |acc, (state, x_range, y_range, z_range)|
        next acc if state == :off

        acc + (x_range.size * y_range.size * z_range.size)
      end
    end

    def cube_volume(limit)
      @cubes.reduce(0) do |acc, (state, x_range, y_range, z_range)|
        next acc if state == :off

        next acc unless ReactorReboot.overlaps?([nil, limit, limit, limit], [state, x_range, y_range, z_range])

        acc + (x_range.size * y_range.size * z_range.size)
      end
    end

    def self.overlaps?((_, c1x, c1y, c1z), (_, c2x, c2y, c2z))
      c1x.end >= c2x.begin && c1x.begin <= c2x.end &&
        c1y.end >= c2y.begin && c1y.begin <= c2y.end &&
        c1z.end >= c2z.begin && c1z.begin <= c2z.end
    end

    def self.split((c1s, c1x, c1y, c1z), (_, c2x, c2y, c2z))
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

    private

    def detect_and_split(potential, cube)
      potential.reduce([]) do |acc, pcube|
        if ReactorReboot.overlaps?(pcube, cube)
          acc + ReactorReboot.split(pcube, cube)
        else
          acc << pcube
        end
      end
    end

    def process_one_cube(new_cube)
      potential = [new_cube]
      # @cubes.each do |cube|
      @cubes[(@cubes.bsearch_index { _1[1].end >= new_cube[1].begin })..].each do |cube|
        potential = detect_and_split(potential, cube)
      end
      @cubes.insert(@cubes.bsearch_index { _1[1].end > new_cube[1].end } || @cubes.size, *potential)
      @cubes.sort_by! { _1[1].end }
    end
  end
end
