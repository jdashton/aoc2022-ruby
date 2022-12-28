# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 23, we're tracing a password.
    class UnstableDiffusion
      def self.day23
        unstable_diffusion = File.open('input/day23.txt') { |file| UnstableDiffusion.new file }
        puts "Day 23, Part One: #{ unstable_diffusion.part_one } is the final password."
        puts "Day 23, Part Two: #{ unstable_diffusion.part_two } is the final password."
        puts
      end

      DIRS = {
        north: ->(x, y) { [x, y - 1] },
        south: ->(x, y) { [x, y + 1] },
        west:  ->(x, y) { [x - 1, y] },
        east:  ->(x, y) { [x + 1, y] }
      }.freeze

      # :reek:FeatureEnvy
      def initialize(file)
        @dirs  = DIRS.keys
        @board = file
                   .readlines(chomp: true)
                   .each_with_index
                   .reduce({}) { |line_acc, (line, y)|
                     # pp [line_acc, line, y_prime]
                     line
                       .chars
                       .each_with_index
                       .reduce(line_acc) { |acc, (char, x)|
                         # pp [acc, char, x_prime]
                         acc.merge(char == '#' ? { [x, y] => '#' } : {})
                       }
                   }
      end

      # Round:
      # 1. considering where to move
      # 2. actually moving
      #
      # Consider the 8 adjacent positions:
      # * All empty: stand pat
      # * N, NE and NW empty ? move N
      # * S, SE and SW empty ? move S
      # * W, NW and SW empty ? move W
      # * E, NE and SE empty ? move E
      #
      # Move as proposed if no other Elf proposed moving to the same spot, else stand pat.
      #
      # Finally, rotate the direction sequence, so that S is considered first in the 2nd round,
      # west in the 3rd round and so forth.
      #   directions = [:north, :south, :west, :east].rotate
      def render
        # puts " -- Rendering #{ @board }"
        xs, ys = [[], []]
        @board.each { |(x, y), _| xs << x; ys << y }

        Range.new(*ys.minmax).map { |y|
          Range.new(*xs.minmax).map { |x|
            @board[[x, y]] || '.'
          }.join
        }.join("\n") + "\n"
      end

      def lonely?((x, y))
        # puts "checking lonely"
        ((y - 1)..(y + 1)).map do |y_prime|
          ((x - 1)..(x + 1)).map do |x_prime|
            next nil if x_prime == x && y_prime == y
            @board[[x_prime, y_prime]]
          end
        end.flatten.all?(&:nil?)
      end

      def empty_dir?((x, y), dir)
        # pp [x, y, dir]
        new_x, new_y = DIRS[dir].call(x, y)
        if dir in :north | :south
          [[x - 1, new_y], [x, new_y], [x + 1, new_y]]
        else
          [[new_x, y - 1], [new_x, y], [new_x, y + 1]]
        end.all? { |pos| @board[pos].nil? }
      end

      def propose_moves
        # puts "Starting propose_moves"
        # pp @board

        num_moves = 0
        @proposed = @board.reduce({}) do |acc, (elf, val)|
          # puts "New elf: #{ acc }, #{ elf }, #{ val }"
          if lonely?(elf)
            # puts "found a lonely elf at #{ elf }"
            acc.merge({ elf => val })
          else
            @dirs.reduce(acc) do |dir_acc, dir|
              # puts "trying #{ [dir] }"
              if empty_dir?(elf, dir)
                # puts "found a direction to move with #{ elf } going #{ dir }"
                new_pos = DIRS[dir].call(*elf)
                # pp [new_pos, dir_acc, elf]
                num_moves += 1
                break dir_acc.merge({ new_pos => ((dir_acc[new_pos] || []) << elf) })
              else
                if dir == @dirs.last
                  dir_acc.merge({ elf => val })
                else
                  dir_acc
                end
              end
            end
          end
        end
        num_moves
      end

      def actuate_moves
        @board = {}
        # pp @proposed
        @proposed.each do |key, props|
          case props
            in "#"
              # puts "Elf succeeds in moving to #{ key }"
              @board[key] = props
            in Array
              if props.length == 1
                # puts "Elf succeeds in moving to #{ key }"
                @board[key] = "#"
              else
                # puts "#{ props.length } Elves cannot move to #{ key }"
                props.each { |pos| @board[pos] = "#" }
              end
            else
              # puts "  --  UNEXPECTED PROPOSAL: #{ key } => #{ props }"
          end
        end
      end

      def spread_out(max_rounds = 10)
        @rounds = 1
        # puts "\n -- starting Round #{ @rounds }\n\n"
        while propose_moves.positive?
          @rounds += 1
          actuate_moves
          @dirs = @dirs.rotate
          break if @rounds > max_rounds
          # puts "\n -- starting Round #{ @rounds }\n\n"
        end
        self
      end

      def count_spaces
        # puts " -- Rendering #{ @board }"
        xs, ys = [[], []]
        @board.each { |(x, y), _| xs << x; ys << y }
        spaces = 0

        Range.new(*ys.minmax).map { |y|
          Range.new(*xs.minmax).map { |x|
            @board[[x, y]].nil? && (spaces += 1)
          }
        }
        spaces
      end

      def part_one
        spread_out.count_spaces
      end

      def part_two
        spread_out(1500)
        @rounds
      end
    end
  end
end
