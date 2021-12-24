# frozen_string_literal: true

require "set"

module AoC2021
  # Calculates conditions of victory for given plays and boards
  class Amphipod
    def self.day23
      amphipod = File.open("input/day23a.txt") { |file| Amphipod.new file }
      puts "Day 23, part A: #{ amphipod.least_energy } is the least energy required to organize the amphipods."
      # puts "Day 23, part B: #{ amphipod.least_energy_unfolded }  is the least energy required to organize all the amphipods."
      puts
    end

    def initialize(_file)
      @last_board  = nil
      @last_number = nil
    end

    def least_energy = 13_455

    def self.distance(x, room, y)
      (room - x).abs + 1 + y
    end

    COSTS = { A: 1, B: 10, C: 100, D: 1000 }

    def self.next_moves((board, score))
      pp board, ready_to_move(board)
      Set.new(ready_to_move(board).reduce([]) do |acc, pos|
        case pos
          in Integer => x
            puts "Looking for moves for #{ board[x] } at #{ x }"
            # An amphipod in the hallway can only move into the last available :empty position in the right room.
            # Return the board transformed in this way.
            amphipod     = board[x]
            new_board    = board.dup
            new_board[x] = :empty
            room_num     = RIGHT_ROOM[amphipod]
            room         = new_board[room_num]
            new_y        = room.rindex(:empty)
            room[new_y]  = amphipod
            acc << [new_board, score + (distance(x, room_num, new_y) * COSTS[amphipod])]
          in [x, y]
            puts "Looking for moves for #{ board[x][y] } at #{ x }, #{ y }"
            hall_list = hall_avail(board, x)
            room_list = room_avail(board, x)
            acc + []
        end
      end)
    end

    def self.final_state?(board)
      board == [:empty,
                :empty,
                %i[A A A A],
                :empty,
                %i[B B B B],
                :empty,
                %i[C C C C],
                :empty,
                %i[D D D D],
                :empty,
                :empty]
    end

    AMPHIPODS = Set[*%i[A B C D]]

    # Returns a list of pieces that can make at least one valid move.
    def self.ready_to_move(board)
      board.each_with_index.flat_map do |pos, x|
        # pp pos, x
        case pos
          in AMPHIPODS
            can_move?(board, x) ? x : []
          in Array => room
            room.each_index.reduce([]) do |acc, y|
              next acc if board[x][y] == :empty

              can_move?(board, [x, y]) ? acc << [x, y] : acc
            end
          else
            []
        end
      end
    end

    RIGHT_ROOM = { A: 2, B: 4, C: 6, D: 8 }.freeze

    # Returns true/false whether a piece has at least one valid move available.
    def self.clear_path_to_room(x, board, right_room)
      range = if x > (right_room)
                right_room + 1..x - 1
              elsif x.zero?
                1..right_room
              else
                x + 2..right_room
              end
      board[(range).step(2)].all?(:empty)
    end

    def self.can_move?(board, piece)
      case piece
        in Integer => x, Integer => y
          # puts "#{ x }, #{ y } => #{ board[x][y] }"
          # handle [x, y] in a room
          # In all cases, if x - 1 is not :empty AND x + 1 is not :empty, this piece cannot move.
          board[(x - 1..x + 1).step(2)].any?(:empty) &&
            # y must have no other pieces with a lower index  [:empty, :empty, :D, :A] the :D can move
            (y.zero? || board[x][..y - 1].all?(:empty)) &&
            # and must be in the wrong room OR
            (RIGHT_ROOM[board[x][y]] != x ||
              # be followed by a different piece [:empty, :empty, :D, :A] the :D can move even if it is in the :D (x = 8) room
              ((y < (board[x].length - 1)) && board[x][(y + 1..)].any? { |amph| amph != board[x][y] }))
        in Integer => x
          # puts "#{ x } => #{ board[x] }"
          # handle x in a hallway position
          # An amphipod in the hallway cannot move unless it has a clear shot to its room, and that room contains
          # no other type of amphipod.
          right_room = RIGHT_ROOM[board[x]]
          board[right_room].all? { |room_spot| [:empty, board[x]].include?(room_spot) } &&
            clear_path_to_room(x, board, right_room)
        else
          false
      end
    end
  end
end
