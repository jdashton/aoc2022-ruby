# frozen_string_literal: true

# Encapsulates operations on lanternfish by day
class FishCalendar
  attr_reader :fish_list

  def initialize(fish_list)
    @fish_list = fish_list.tally
  end

  def next_day
    spawning_fish = @fish_list[0]
    @fish_list    = @fish_list.transform_keys { |key| key.zero? ? 8 : key - 1 }
                              .merge(6 => (spawning_fish || 0)) { |_, old, new| old + new }
  end
end

module AoC2021
  # Implements solution for Day 6 puzzles
  class Lanternfish
    def initialize(file)
      @calendar = FishCalendar.new(file.readline(chomp: true).split(/,/).map(&:to_i))
    end

    def compounded(days = 80)
      days.times { |_| @calendar.next_day }
      @calendar.fish_list.values.reduce(0) { |acc, num| acc + (num || 0) }
    end
  end
end
