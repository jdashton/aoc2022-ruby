# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 12, we're seeking a better signal.
    class HillClimbingAlgorithm
      def self.day12
        hill_climbing_algorithm = File.open('input/day12.txt') { |file| HillClimbingAlgorithm.new file }
        puts "Day 12, Part One: #{ hill_climbing_algorithm.fewest_steps } is the fewest steps required."
        puts "Day 12, Part Two: #{ hill_climbing_algorithm.fewest_steps_downhill } is the fewest steps required."
        puts
      end

      def initialize(file)
        @height_map  = {}
        @start       = [nil, nil]
        @destination = [nil, nil]
        file.readlines(chomp: true).map(&:chars).each_with_index do |line_ary, y_index|
          line_ary.each_with_index do |height, x_index|
            case height
              when 'S'
                @start = [x_index, y_index]
              when 'E'
                @destination = [x_index, y_index]
                height       = 'z'
            end
            @height_map[[x_index, y_index]] = height
          end
        end
      end

      def to_s
        # pp @risk_map
        max_x = @height_map.max_by { |(x, _), _| x }[0][0]
        max_y = @height_map.max_by { |(_, y), _| y }[0][1]
        # pp max_x, max_y

        str = String.new
        (0..max_y).each do |y|
          (0..max_x).each do |x|
            str << @height_map[[x, y]].to_s
          end
          str << "\n"
        end

        str
      end

      def fewest_steps
        dijkstra
      end

      def fewest_steps_downhill
        dijkstra do |costs, nearby|
          nearby[0] = []
          costs.each_key { |(x, y)| nearby[0] << [x, y] if x.zero? }
          [costs.to_h { |(x, y), v| [[x, y], (x.zero? ? 0 : v)] }, nearby]
        end
      end

      def dijkstra
        # 1. Mark all nodes unvisited. Create a set of all the unvisited nodes called the unvisited set.
        #
        # Our original map in @risk_map can be the unvisited. We could replace nodes with `nil` to mark them visited.
        costs = @height_map.transform_values { Float::INFINITY }

        # 2. Assign to every node a tentative distance value: set it to zero for our initial node and to infinity for all other
        # nodes. The tentative distance of a node v is the length of the shortest path discovered so far between the node v and
        # the starting node. Since initially no path is known to any other vertex than the source itself (which is a path of
        # length zero), all other tentative distances are initially set to infinity. Set the initial node as current.[15]
        #
        current_node        = @start
        current_reachable   = 'b'
        costs[current_node] = 0
        nearby              = {}
        costs, nearby       = yield(costs, nearby) if block_given?

        # destination                 = @risk_map.max_by { |(x, y), _| x * y }[0]
        # # puts "Setting destination to #{ destination }."
        # risks[current_node] = 0

        loop do
          # 3. For the current node, consider all of its unvisited neighbors and calculate their tentative distances through the
          # current node. Compare the newly calculated tentative distance to the current assigned value and assign the smaller
          # one. For example, if the current node A is marked with a distance of 6, and the edge connecting it with a neighbor B
          # has length 2, then the distance to B through A will be 6 + 2 = 8. If B was previously marked with a distance greater
          # than 8 then change it to 8. Otherwise, the current value will be kept.
          #
          neighbors(current_node).each do |neighbor|
            # pp "Unfiltered neighbor #{ neighbor } with #{ @height_map[neighbor] }"
            next unless costs[current_node] # This detects when the current node has already been processed.
            next unless costs[neighbor] # This detects neighbors that are not available to visit, like edges.
            next unless (@height_map[neighbor]) <= current_reachable # (current_height.ord + 1).chr

            # pp "  -- not off-board and not too high to reach"

            new_cost = costs[current_node] + 1
            if new_cost < costs[neighbor]
              costs[neighbor]  = new_cost
              nearby[new_cost] = (nearby[new_cost] || []) << neighbor
            end
          end

          # 4. When we are done considering all of the unvisited neighbors of the current node, mark the current node as visited
          # and remove it from the unvisited set. A visited node will never be checked again.
          #
          costs.delete(current_node)
          # pp costs

          # 5. If the destination node has been marked visited (when planning a route between two specific nodes) or if the
          # smallest tentative distance among the nodes in the unvisited set is infinity (when planning a complete traversal;
          # occurs when there is no connection between the initial node and remaining unvisited nodes), then stop. The algorithm
          # has finished.
          #

          # 6. Otherwise, select the unvisited node that is marked with the smallest tentative distance, set it as the new
          # current node, and go back to step 3.
          # pp nearby
          nearest      = nearby.keys.min
          current_node = nearby[nearest].shift
          nearby.delete(nearest) if nearby[nearest].empty?
          current_reachable = (@height_map[current_node].ord + 1).chr
          if current_node == @destination
            # puts "Can reach #{ destination } with risk of #{ risks[destination] }."
            return costs[@destination]
          end
        end
      end

      def neighbors((x, y))
        [
          [x - 1, y],
          [x + 1, y],
          [x, y - 1],
          [x, y + 1]
        ]
      end
    end
  end
end
