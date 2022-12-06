# frozen_string_literal: true

Dir["#{ File.dirname(__FILE__) }/puzzles/*.rb"].each { |file| require file }

module AoC2022
  # The Runner class provides file loading services around the solution for each day.
  class Runner
    def self.start
      puts
      find_day_methods
    end

    def self.find_day_methods
      AoC2022::Puzzles
        .constants
        .map { |constant| AoC2022::Puzzles.const_get(constant) }
        .select { |constant| constant.is_a? Class }
        .reduce([], &method(:pick_day_methods))
        .sort_by { |_, method_name| method_name }
        .each { |class_name, method_name| class_name.send method_name }
    end

    def self.pick_day_methods(acc, class_name)
      acc + class_name.methods.grep(/day\d\d/).map { |method_name| [class_name, method_name] }
    end
  end
end
