# frozen_string_literal: true

module AoC2021
  # CavePaths implements the solutions for Day 12.
  class CavePaths
    def self.day12
      paths = File.open("input/day12a.txt") { |file| CavePaths.new file }
      puts "Day 12, part A: #{ paths.single_visit_size } paths through this cave system that visit small caves at most once"
      # puts "Day 12, part B: #{ paths.double_visit_size } paths through this cave system with revised visit rules"
      puts
    end

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

    def uncertain_explore(this_node, lower_visited = [])
      # if first letter is larger than 'Z'
      new_lower_visited = (this_node[0] > "Z" ? lower_visited + [this_node] : lower_visited)
      # Try "if this_node is small and is in lower_visited"
      # change to hash lookup, only check double for the node we are currently visiting
      return certain_explore(this_node, lower_visited) if new_lower_visited.tally.any? { |_, val| val > 1 }

      (@edges[this_node]).each { |next_node| uncertain_process_next_nodes(next_node, new_lower_visited) }
    end

    def certain_explore(this_node, lower_visited = [])
      (@edges[this_node] - lower_visited) # Try to iterate over @edges[this_node], as it is smaller. Can short-circuit if < 'a'.
        .each do |next_node|
        certain_process_next_nodes(next_node, (this_node[0] > "Z" ? lower_visited + [this_node] : lower_visited))
      end
    end

    private

    def uncertain_process_next_nodes(next_node, new_lower_visited)
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
