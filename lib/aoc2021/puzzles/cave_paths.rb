# frozen_string_literal: true

module AoC2021
  # CavePaths implements the solutions for Day 12.
  class CavePaths
    extend Forwardable

    def initialize(file)
      @edges = Hash.new { |hash, key| hash[key] = Set.new }
      file.readlines(chomp: true).map { |line| line.split("-") }.each do |node_a, node_b|
        @edges[node_a].add node_b unless node_b == "start" || node_a == "end"
        @edges[node_b].add node_a unless node_a == "start" || node_b == "end"
      end
      @successes = 0
    end

    def single_visit_size
      @successes = 0
      certain_explore("start")
      @successes
    end

    def double_visit_size
      @successes = 0
      uncertain_explore("start")
      @successes
    end

    def uncertain_explore(node, lower_visited = [])
      new_lower_visited = (node == node.downcase ? lower_visited + [node] : lower_visited)
      return certain_explore(node, lower_visited) if new_lower_visited.tally.any? { |_, val| val > 1 }

      (@edges[node])
        .each { |next_node| process_next_nodes(next_node, new_lower_visited) }
    end

    def certain_explore(node, lower_visited = [])
      (@edges[node] - lower_visited)
        .each { |next_node| certain_process_next_nodes(next_node, (node == node.downcase ? lower_visited + [node] : lower_visited)) }
    end

    private

    def process_next_nodes(next_node, new_lower_visited)
      if next_node == "end"
        @successes += 1
      else
        uncertain_explore(next_node, new_lower_visited)
      end
    end

    def certain_process_next_nodes(next_node, new_lower_visited)
      if next_node == "end"
        @successes += 1
      else
        certain_explore(next_node, new_lower_visited)
      end
    end
  end
end
