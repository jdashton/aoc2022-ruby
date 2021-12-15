# frozen_string_literal: true

require "dijkstra"

module AoC2021
  # Chitons implements the solutions for Day 12.
  class Chitons
    extend Forwardable

    def initialize(file)
      @risk_map = file.readlines(chomp: true).map(&:chars).each_with_index.flat_map do |line_ary, y_index|
        line_ary.each_with_index.flat_map do |risk_val, x_index|
          [
            ["#{ x_index - 1 }, #{ y_index }", "#{ x_index }, #{ y_index }", risk_val.to_i],
            ["#{ x_index + 1 }, #{ y_index }", "#{ x_index }, #{ y_index }", risk_val.to_i],
            ["#{ x_index }, #{ y_index - 1 }", "#{ x_index }, #{ y_index }", risk_val.to_i],
            ["#{ x_index }, #{ y_index + 1 }", "#{ x_index }, #{ y_index }", risk_val.to_i]
          ]
        end
      end
      # pp @risk_map
    end

    def dijkstra = 0

    def lowest_risk
      r = [[1, 2, 1],
           [1, 3, 9],
           [1, 5, 3],
           [2, 4, 3],
           [2, 3, 7],
           [4, 3, 2],
           [4, 1, 1],
           [5, 2, 4],
           [5, 4, 2]]

      start_point = 1 # starting node
      end_point   = 3 # arrival node

      ob = Dijkstra.new(start_point, end_point, r)

      puts "Cost = #{ ob.cost }"
      puts "Shortest Path from #{ start_point } to #{ end_point } = #{ ob.shortest_path }"
    end

    # def lowest_risk = Dijkstra.new("0, 0", "9, 9", @risk_map).cost
  end
end
