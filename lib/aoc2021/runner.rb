# frozen_string_literal: true

Dir["#{ File.dirname(__FILE__) }/puzzles/*.rb"].each { |file| require file }

module AoC2021
  # The Runner class provides file loading services around the solution for each day.
  class Runner
    def self.start
      methods.filter { |method| method.name.start_with? "day" }.sort.each { |method| send method }
    end

    def self.day01
      depths = File.open("input/day01a.txt") { |file| SonarDepth.new file }
      puts "Day  1, part A: #{ depths.count_increases } increases"
      puts "Day  1, part B: #{ depths.count_triplet_increases } triplet increasesOrigami"
      puts
    end

    def self.day02
      commands = File.open("input/day02a.txt") { |file| PilotCommands.new file }
      puts "Day  2, part A: #{ commands.exec_commands } product of horizontal position and depth"
      puts "Day  2, part B: #{ commands.exec_with_aim } product of horizontal position and depthOrigami"
      puts
    end

    def self.day03
      diag_bits = File.open("input/day03a.txt") { |file| DiagnosticBits.new file }
      puts "Day  3, part A: #{ diag_bits.power_consumption } product of gamma and epsilon"
      puts "Day  3, part B: #{ diag_bits.life_support_rating } product of oxygen generator and CO2 scrubber ratingsOrigami"
      puts
    end

    def self.day04
      bingo = File.open("input/day04a.txt") { |file| Bingo.new file }
      puts "Day  4, part A: #{ bingo.victory } predicted score at victory"
      puts "Day  4, part B: #{ bingo.last_win } predicted score on board that 'wins' lastOrigami"
      puts
    end

    def self.day05
      vents = File.open("input/day05a.txt") { |file| Vents.new file }
      puts "Day  5, part A: #{ vents.overlaps } vents that are in two or more lines (horizontal or vertical)"
      puts "Day  5, part B: #{ vents.overlaps_with_diagonals } vents in any two or more lines (including diagonal)Origami"
      puts
    end

    def self.day06
      lanternfish = File.open("input/day06a.txt") { |file| Lanternfish.new file }
      puts "Day  6, part A: #{ lanternfish.compounded } lanternfish after 80 days"
      puts "Day  6, part B: #{ lanternfish.compounded(256 - 80) } lanternfish after 256 daysOrigami"
      puts
    end

    def self.day07
      crab_subs = File.open("input/day07a.txt") { |file| CrabSubs.new file }
      puts "Day  7, part A: #{ crab_subs.minimal_move } fuel used in moving to a common position"
      puts "Day  7, part B: #{ crab_subs.minimal_move_revised } fuel used in moving to a common position (revised)Origami"
      puts
    end

    def self.day08
      segments = File.open("input/day08a.txt") { |file| Segments.new file }
      puts "Day  8, part A: #{ segments.easy_digits } display chunks with identifiable patterns"
      puts "Day  8, part B: #{ segments.sum_of_all_outputs } sum of all of the output valuesOrigami"
      puts
    end

    def self.day09
      smoke_points = File.open("input/day09a.txt") { |file| SmokePoints.new file }
      puts "Day  9, part A: #{ smoke_points.risk_levels } sum of the risk levels of all low points"
      puts "Day  9, part B: #{ smoke_points.multiply_basins } product of three largest basin sizesOrigami"
      puts
    end

    def self.day10
      syntax = File.open("input/day10a.txt") { |file| Syntax.new file }
      puts "Day 10, part A: #{ syntax.illegal_points } sum of points for illegal closing brackets"
      puts "Day 10, part B: #{ syntax.autocomplete } middle score for completing incomplete stringsOrigami"
      puts
    end

    def self.day11
      flashes = File.open("input/day11a.txt") { |file| OctopusFlashes.new file }
      puts "Day 11, part A: #{ flashes.total(100) } total flashes after 100 steps"
      puts "Day 11, part B: #{ flashes.synchronized_at } steps until all octopuses flash together"
      puts
    end

    def self.day12
      paths = File.open("input/day12a.txt") { |file| CavePaths.new file }
      puts "Day 12, part A: #{ paths.single_visit_size } paths through this cave system that visit small caves at most once"
      puts "Day 12, part B: #{ paths.double_visit_size } paths through this cave system with revised visit rules"
      puts
    end

    def self.day13
      folds_and_points = File.open("input/day13a.txt") { |file| Origami.new file }
      puts "Day 13, part A: #{ folds_and_points.first_fold.visible_dots } dots visible after completing first fold instruction"
      puts "Day 13, part B: \n#{ folds_and_points.final_shape }"
      puts
    end

    def self.day14
      polymers = File.open("input/day14a.txt") { |file| Polymers.new file }
      puts "Day 14, part A: #{ polymers.process(10) } difference between the most and least common elements after 10 iterations"
      puts "Day 14, part B: #{ polymers.process(40) } difference between the most and least common elements after 40 iterations"
      puts
    end

    def self.day15
      chitons = File.open("input/day15a.txt") { |file| Chitons.new file }
      puts "Day 15, part A: #{ chitons.lowest_risk } is the lowest total risk of any path from the top left to the bottom right"
      # puts "Day 15, part B: #{ chitons } difference between the most and least common elements after 40 iterations"
      puts
    end
  end
end
