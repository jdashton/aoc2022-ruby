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
      # puts "---------- VISITING #{ this_node }"
      # return if visited&.reject { |node| node == node.upcase }.tally.values.tally[2]&.>(1)

      if visited.reject { |node| node == node.upcase }.tally.values.tally[2]&.>(1)
        puts "\n!!!!!!!!!! Got here with at least two duplicate lower-case visits !!!!!!!!!!"
        pp visited
        exit
      end

      visited = visited << this_node

      # puts "At #{ this_node } after #{ visited }"
      if this_node == :end
        @successes += [visited]
        # puts "Found an :end. @successes is now #{ @successes }"
        return
      end

      edges_from_here = @edges[this_node]
      if yield(visited)
        # puts "We got a block: visited is #{ visited }"
        edges_from_here -= visited.reject { |node| node == node.upcase }
        # print "-- revised edges: "
        # pp edges_from_here
        # puts
      end
      return if edges_from_here.empty?

      # puts
      # puts " .. Thinking about these edges: #{edges_from_here}"

      edges_from_here.each do |node|
        # puts "About to visit #{ node }. visited is #{ visited }"
        # name_is_lowercase = (node == node.downcase)
        # node_already_visited = visited.include?(node)
        # visited_contains_a_duplicate = visited.reject { |name| name == name.upcase }.tally.values.any? { |num| num > 1 }
        # # visited
        # next if name_is_lowercase && node_already_visited && visited_contains_a_duplicate

        # puts " .. passed .. visiting #{node}"
        explore node, visited.dup, &block
      end
    end

    def double_visit
      explore(:start) { |visited| visited.reject { |node| node == node.upcase }&.tally&.any? { |_, tal| tal > 1 } }
      @successes.map { |path| path.map(&:to_s).join(",") }.sort.join("\n") << "\n"
    end

    def double_visit_size
      explore(:start) { |visited| visited.reject { |node| node == node.upcase }&.tally&.any? { |_, tal| tal > 1 } }
      # pp @successes
      @successes.size
    end
  end
end
