# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 9, we're move the rope's tail.
    class RopeBridge
      def self.day09
        rope_bridge = File.open("input/day09.txt") { |file| RopeBridge.new file }
        puts "Day  9, part A: The tail of the rope visits #{ rope_bridge.short_positions } positions at least once."
        puts "Day  9, part A: The tail of the longer rope visits #{ rope_bridge.long_rope_positions } positions at least once."
        puts
      end

      def initialize(file)
        @lines =
          file
            .readlines(chomp: true)
            .map(&:split)
      end

      def reset_rope
        @head    = [0, 0]
        @tail    = [0, 0]
        @visited = Set[[0, 0].map(&:to_s).join(?,)]
        @knots   = 8.times.reduce([]) { |acc, _| acc << [0, 0] }
      end

      def move(direction, distance, scenario = :short)
        distance.to_i.times do
          case direction
            when ?R then @head[0] += 1
            when ?L then @head[0] -= 1
            when ?U then @head[1] -= 1
            when ?D then @head[1] += 1
            else
          end
          if scenario == :short
            @tail = move_tail(@head, @tail)
          else
            @knots[0] = move_tail(@head, @knots[0])
            (0..7).each_cons(2) { |a, b| @knots[b] = move_tail(@knots[a], @knots[b]) }
            @tail = move_tail(@knots[7], @tail)
          end
          @visited << @tail.map(&:to_s).join(?,)
        end
      end

      def move_tail(k_head, k_tail)
        return k_tail if (k_head[0] - k_tail[0]).abs <= 1 && (k_head[1] - k_tail[1]).abs <= 1

        if k_head[0] == k_tail[0]
          # move left or right
          k_tail[1] += (k_head[1] > k_tail[1]) ? +1 : -1
        elsif k_head[1] == k_tail[1]
          # move up or down
          k_tail[0] += (k_head[0] > k_tail[0]) ? +1 : -1
        else
          # move diagonally -- means we definitely will move one step both horizontally and vertically.
          # We just need to know which direction for each dimension.
          k_tail[1] += (k_head[1] > k_tail[1]) ? +1 : -1
          k_tail[0] += (k_head[0] > k_tail[0]) ? +1 : -1
        end
        k_tail
      end

      def short_positions
        reset_rope
        # pp @lines
        @lines.each { |line| move(*line) }
        # pp @visited
        @visited.size
      end

      def long_rope_positions
        reset_rope
        @lines.each { |line| move(*line, :long) }
        @visited.size
      end
    end
  end
end
