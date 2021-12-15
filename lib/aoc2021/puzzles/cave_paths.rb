# frozen_string_literal: true

module AoC2021
  # CavePaths implements the solutions for Day 12.
  class CavePaths
    extend Forwardable
    def_instance_delegators :@successes, :size

    def initialize(file)
      @edges = Hash.new { |hash, key| hash[key] = Set.new }
      file.readlines(chomp: true)
          .map do |line|
        node_a, node_b = line.split("-").map(&:to_sym)
        @edges[node_a].add node_b unless node_b == :start
        @edges[node_b].add node_a unless node_a == :start
      end
      @successes = Set.new
      explore(:start) { |_| true }
    end

    def successes
      @successes.map { |path| path.map(&:to_s).join(",") }.sort.join("\n") << "\n"
    end

    def explore(this_node, visited = [], &block)
      # Array#+ returns a new array, leaving the old one unchanged.
      new_visited = visited + [this_node]

      # Set#<< seems to be two orders of magnitude faster than Set#+
      return @successes << new_visited if this_node == :end

      edges_from_here = @edges[this_node] - (yield(new_visited) ? visited.reject { |node| node == node.upcase } : [])
      return if edges_from_here.empty?

      edges_from_here.each do |node|
        explore node, new_visited, &block
      end
    end

    def double_visit
      explore(:start) { |visited| visited.reject { |node| node == node.upcase }.tally.any? { |_, tal| tal > 1 } }
      @successes.map { |path| path.map(&:to_s).join(",") }.sort.join("\n") << "\n"
    end

    def double_visit_size
      explore(:start) { |visited| visited.reject { |node| node == node.upcase }.tally.any? { |_, tal| tal > 1 } }
      @successes.size
    end
  end
end
