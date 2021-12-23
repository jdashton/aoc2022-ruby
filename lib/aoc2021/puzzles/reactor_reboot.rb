# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Rebooting cubes in the reactor for Day 22
  class ReactorReboot
    def self.day22
      reactor_reboot = File.open("input/day22a.txt") { |file| ReactorReboot.new file }
      puts "Day 22, part A: #{ reactor_reboot.count_true } cubes are on."
      # puts "Day 22, part B: Player 1: #{ (wins = reactor_reboot.dirac_to_score(3))[0] } universes,
      # Player 2: #{ wins[1] } universes"
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
      @raw_steps.each(&method(:process_one_cube))
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
      @cubes.reduce(0) do |acc, (x_range, y_range, z_range)|
        acc + ((x_range.max - x_range.min + 1) * (y_range.max - y_range.min + 1) * (z_range.max - z_range.min + 1))
      end
    end

    def overlaps?((c1x, c1y, c1z), (c2x, c2y, c2z))
      puts "#{ [c1x, c1y, c1z] }, #{ [c2x, c2y, c2z] }"
      Set[*c1x].intersect?(Set[*c2x]) && Set[*c1y].intersect?(Set[*c2y]) && Set[*c1z].intersect?(Set[*c2z])
    end

    def split(cube1, _cube2)
      puts "Need to split #{ cube1 }"
      [cube1]
    end

    def detect_and_split(potential, cube)
      potential.reduce([]) do |acc, pcube|
        if overlaps?(pcube, cube)
          acc + split(pcube, cube)
        else
          acc << pcube
        end
      end
    end

    def process_one_cube((power, x_range, y_range, z_range))
      return unless power == :on

      potential = [[x_range, y_range, z_range]]
      @cubes.each do |cube|
        potential = detect_and_split(potential, cube)
      end
      @cubes += potential
    end

    def run_step(step) = step[3].each { |page_num| mark_page page_num, step }

    def mark_page(page_num, step) = step[2].each { |row_num| self.class.mark_row (@space[page_num] ||= []), row_num, step }
  end
end
