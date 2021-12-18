# frozen_string_literal: true

Dir["#{ File.dirname(__FILE__) }/puzzles/*.rb"].each { |file| require file }

module AoC2021
  # The Runner class provides file loading services around the solution for each day.
  class Runner
    def self.start
      puts
      find_day_methods
    end

    def self.find_day_methods
      AoC2021.constants
             .map { |c| AoC2021.const_get(c) }
             .select { |c| c.is_a? Class }
             .reduce([], &method(:pick_day_methods))
             .sort_by { |_, m| m }
             .each { |c, m| c.send m }
    end

    def self.pick_day_methods(acc, class_name)
      acc + class_name.methods.grep(/day\d\d/).map { |m| [class_name, m] }
    end
  end
end
