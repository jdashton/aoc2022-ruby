# frozen_string_literal: true

module AoC2021
  # Chitons implements the solutions for Day 15.
  class Chitons
    extend Forwardable

    def initialize(file)
      @risk_map = {}
      file.readlines(chomp: true).map(&:chars).each_with_index do |line_ary, y_index|
        line_ary.each_with_index do |risk_val, x_index|
          @risk_map[[x_index, y_index]] = risk_val.to_i
        end
      end
    end

    def to_s
      # pp @risk_map
      max_x = @risk_map.max_by { |(x, _), _| x }[0][0]
      max_y = @risk_map.max_by { |(_, y), _| y }[0][1]
      # pp max_x, max_y

      str = String.new
      (0..max_y).each do |y|
        (0..max_x).each do |x|
          str << @risk_map[[x, y]].to_s
        end
        str << "\n"
      end

      str
    end

    def times_five
      max_x = @risk_map.max_by { |(x, _), _| x }[0][0]
      max_y = @risk_map.max_by { |(_, y), _| y }[0][1]
      off_x = max_x + 1
      (0..max_y).each do |y|
        (0..max_x).each do |x|
          @risk_map[[(off_x * 1) + x, y]] = @risk_map[[(off_x * 0) + x, y]] + 1 < 10 ? @risk_map[[(off_x * 0) + x, y]] + 1 : 1
          @risk_map[[(off_x * 2) + x, y]] = @risk_map[[(off_x * 1) + x, y]] + 1 < 10 ? @risk_map[[(off_x * 1) + x, y]] + 1 : 1
          @risk_map[[(off_x * 3) + x, y]] = @risk_map[[(off_x * 2) + x, y]] + 1 < 10 ? @risk_map[[(off_x * 2) + x, y]] + 1 : 1
          @risk_map[[(off_x * 4) + x, y]] = @risk_map[[(off_x * 3) + x, y]] + 1 < 10 ? @risk_map[[(off_x * 3) + x, y]] + 1 : 1
        end
      end
      max_x = @risk_map.max_by { |(x, _), _| x }[0][0]
      off_y = max_y + 1
      (0..max_y).each do |y|
        (0..max_x).each do |x|
          @risk_map[[x, (off_y * 1) + y]] = @risk_map[[x, (off_y * 0) + y]] + 1 < 10 ? @risk_map[[x, (off_y * 0) + y]] + 1 : 1
          @risk_map[[x, (off_y * 2) + y]] = @risk_map[[x, (off_y * 1) + y]] + 1 < 10 ? @risk_map[[x, (off_y * 1) + y]] + 1 : 1
          @risk_map[[x, (off_y * 3) + y]] = @risk_map[[x, (off_y * 2) + y]] + 1 < 10 ? @risk_map[[x, (off_y * 2) + y]] + 1 : 1
          @risk_map[[x, (off_y * 4) + y]] = @risk_map[[x, (off_y * 3) + y]] + 1 < 10 ? @risk_map[[x, (off_y * 3) + y]] + 1 : 1
        end
      end
      self
    end

    def neighbors((x, y))
      [
        [x - 1, y],
        [x + 1, y],
        [x, y - 1],
        [x, y + 1]
      ]
    end

    def dijkstra
      # 1. Mark all nodes unvisited. Create a set of all the unvisited nodes called the unvisited set.
      #
      # Our original map in @risk_map can be the unvisited. We could replace nodes with `nil` to mark them visited.
      risks = @risk_map.transform_values { |_| Float::INFINITY }
      # pp @risk_map

      # 2. Assign to every node a tentative distance value: set it to zero for our initial node and to infinity for all other
      # nodes. The tentative distance of a node v is the length of the shortest path discovered so far between the node v and
      # the starting node. Since initially no path is known to any other vertex than the source itself (which is a path of
      # length zero), all other tentative distances are initially set to infinity. Set the initial node as current.[15]
      #
      #
      current_node = [0, 0]
      destination  = @risk_map.max_by { |(x, y), _| x * y }[0]
      # puts "Setting destination to #{ destination }."
      risks[current_node] = 0

      loop do
        # 3. For the current node, consider all of its unvisited neighbors and calculate their tentative distances through the
        # current node. Compare the newly calculated tentative distance to the current assigned value and assign the smaller
        # one. For example, if the current node A is marked with a distance of 6, and the edge connecting it with a neighbor B
        # has length 2, then the distance to B through A will be 6 + 2 = 8. If B was previously marked with a distance greater
        # than 8 then change it to 8. Otherwise, the current value will be kept.
        #
        neighbors(current_node).each do |neighbor|
          next unless risks[neighbor] # This detects neighbors that are available to visit

          new_risk        = risks[current_node] + @risk_map[neighbor]
          risks[neighbor] = new_risk if new_risk < risks[neighbor]
        end

        # 4. When we are done considering all of the unvisited neighbors of the current node, mark the current node as visited
        # and remove it from the unvisited set. A visited node will never be checked again.
        #
        risks.delete(current_node)
        # pp risks

        # 5. If the destination node has been marked visited (when planning a route between two specific nodes) or if the
        # smallest tentative distance among the nodes in the unvisited set is infinity (when planning a complete traversal;
        # occurs when there is no connection between the initial node and remaining unvisited nodes), then stop. The algorithm
        # has finished.
        #

        # 6. Otherwise, select the unvisited node that is marked with the smallest tentative distance, set it as the new current
        # node, and go back to step 3.
        #
        current_node = risks.min_by { |_, v| v }[0]
        if current_node == destination
          # puts "Can reach #{ destination } with risk of #{ risks[destination] }."
          return risks[destination]
        end
      end
    end
  end
end
