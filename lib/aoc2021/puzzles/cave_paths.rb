# frozen_string_literal: true

module AoC2021
  # CavePaths implements the solutions for Day 12.
  class CavePaths
    extend Forwardable
    def_instance_delegators "self.class", :two_or_more

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
      explore("start") { |_| true }
      @successes
    end

    def double_visit_size
      @successes = 0
      explore("start") { |visited| visited.tally.any?(&method(:two_or_more)) }
      @successes
    end

    def explore(node, lower_visited = [], &block)
      new_lower_visited = (node == node.downcase ? lower_visited + [node] : lower_visited)
      (@edges[node] - (yield(new_lower_visited) ? new_lower_visited : []))
        .each { |next_node| process_next_nodes(next_node, new_lower_visited, block) }
    end

    def self.two_or_more((_, val))
      val > 1
    end

    private

    def process_next_nodes(next_node, new_lower_visited, block)
      if next_node == "end"
        @successes += 1
      else
        explore(next_node, new_lower_visited, &block)
      end
    end
  end
end
