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
        @edges[node_a].add node_b
        @edges[node_b].add node_a
      end
      # pp @edges
      @successes = Set.new
      explore(:start)
    end

    def successes
      @successes.map { |path| path.map(&:to_s).join(",") }.sort.join("\n") << "\n"
    end

    def explore(first_node, visited = [])
      # puts "At #{ first_node } after #{visited}"
      if first_node == :end
        @successes += [visited << :end]
        return
      end

      edges_from_here = @edges[first_node] - visited.reject { |node| node.to_s.chars.first >= 'A' && node.to_s.chars.first <= 'Z' }
      # pp edges_from_here
      return :failure if edges_from_here.empty?

      edges_from_here.each do |edge|
        explore edge, visited + [first_node]
      end
    end
  end
end
