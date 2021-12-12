# frozen_string_literal: true

module AoC2021
  # OctopusFlashes implements the solutions for Day 11.
  class CavePaths
    extend Forwardable
    def_instance_delegators :@successes, :count
    attr_reader :successes

    def initialize(file)
      @edges = Hash.new { |hash, key| hash[key] = Set.new }
      file.readlines(chomp: true)
          .map do |line|
        node_a, node_b = line.split("-").map(&:to_sym)
        @edges[node_a].add node_b
        @edges[node_b].add node_a
      end
      pp @edges
      @successes = Set.new
      explore(:start)
    end

    def explore(first_node, visited = Set.new)
      puts "At #{ first_node }"
      return [:end] if first_node == :end

      edges_from_here = @edges[first_node] - visited
      pp edges_from_here
      return :failure if edges_from_here.empty?

      edges_from_here.each do |edge|
        new_path = explore edge, visited + [first_node]
        puts " -- tried #{edge}, found #{new_path}"
        return :failure if new_path == :failure
        return new_path << visited # if new_path.first == :end
      end
    end
  end
end
