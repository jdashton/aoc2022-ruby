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

    def initialize(file)
      lines = file.readlines(chomp: true)
      board = Array.new(11)
      HALL_SPOTS.each { |spot| board[spot] = :empty }
      ROOMS.each { |room_num| board[room_num] = [] }
      (0..1).each do |room_spot|
        /#+([A-D])#([A-D])#([A-D])#([A-D])#+/.match(lines[room_spot + 2]) do |md|
          board[2][room_spot] = md[1].to_sym
          board[4][room_spot] = md[2].to_sym
          board[6][room_spot] = md[3].to_sym
          board[8][room_spot] = md[4].to_sym
        end
      end
      @board     = [board, 0]
      @low_score = Float::INFINITY
    end

    def least_energy = 13_455

    def play_game(board = @board)
      return if board[1] >= @low_score

      self.class.next_moves(board).each do |next_board|
        if self.class.final_state?(next_board)
          puts "final state: #{ @low_score = next_board[1] }" if next_board[1] < @low_score
        else
          play_game(next_board) if next_board[1] < @low_score
        end
      end
      @low_score
    end

    def self.distance(x, room, y)
      (room - x).abs + 1 + y
    end

    COSTS = { A: 1, B: 10, C: 100, D: 1000 }.freeze

    HALL_SPOTS = [0, 1, 3, 5, 7, 9, 10].freeze

    def self.hall_avail(board, old_room, score)
      amphipod  = board[old_room].reject { |spot| spot == :empty }.first
      room_spot = board[old_room].index(amphipod)
      HALL_SPOTS.filter { |hall_spot| clear_path_to?(hall_spot, old_room, board) }
                .reduce([]) do |acc, hall_spot|
        new_board                      = board.map(&:clone)
        new_board[hall_spot]           = amphipod
        new_board[old_room][room_spot] = :empty
        # print "found "
        # pp [new_board, score + (distance(hall_spot, room, room_spot) * COSTS[amphipod])]
        acc << [new_board, score + (distance(hall_spot, old_room, room_spot) * COSTS[amphipod])]
      end
    end

    def self.room_avail(board, old_room, score)
      amphipod   = board[old_room].reject { |spot| spot == :empty }.first
      right_room = RIGHT_ROOM[amphipod]
      return [] unless board[right_room].all? { |room_spot| [:empty, amphipod].include?(room_spot) } &&
        clear_path_to?(right_room, old_room, board)

      new_board                            = board.map(&:clone)
      new_room_spot                        = board[right_room].rindex(:empty)
      new_board[right_room][new_room_spot] = amphipod
      old_room_spot                        = board[old_room].index(amphipod)
      new_board[old_room][old_room_spot]   = :empty
      # print "found "
      # pp [new_board, score + (distance(right_room, old_room, old_room_spot + new_room_spot + 1) * COSTS[amphipod])]
      [[new_board, score + (distance(right_room, old_room, old_room_spot + new_room_spot + 1) * COSTS[amphipod])]]
    end

    def self.next_moves((board, score))
      # pp board, ready_to_move(board)
      Set.new(ready_to_move(board).reduce([]) do |acc, pos|
        # pp board, pos
        case pos
          in Integer => x
            # puts "Looking for moves for #{ board[x] } at #{ x }"
            # An amphipod in the hallway can only move into the last available :empty position in the right room.
            # Return the board transformed in this way.
            amphipod     = board[x]
            new_board    = board.map(&:clone)
            new_board[x] = :empty
            room_num     = RIGHT_ROOM[amphipod]
            room         = new_board[room_num]
            new_y        = room.rindex(:empty)
            if new_y.nil?
              pp room, board
            end
            room[new_y]  = amphipod
            acc << [new_board, score + (distance(x, room_num, new_y) * COSTS[amphipod])]
          in [x, y]
            # puts "Looking for moves for #{ board[x][y] } at #{ x }, #{ y }"
            hall_list = hall_avail(board, x, score)
            room_list = room_avail(board, x, score)
            acc + hall_list + room_list
        end
      end)
    end

    def self.final_state?((board, score))
      board.values_at(*HALL_SPOTS).all?(:empty) &&
        board.values_at(*ROOMS).zip(ROOMS).all? { |(room, num)| room.all?(ROOM_AMPHIPOD[num]) }
    end

    AMPHIPODS = Set[*%i[A B C D]]

    # Returns a list of pieces that can make at least one valid move.
    def self.ready_to_move(board)
      # pp board
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

    RIGHT_ROOM    = { A: 2, B: 4, C: 6, D: 8 }.freeze
    ROOM_AMPHIPOD = RIGHT_ROOM.invert

    ROOMS = Set[2, 4, 6, 8]

    # Returns true/false whether a piece has at least one valid move available.
    def self.clear_path_to?(destination_x, start_x, board)
      range = if destination_x < start_x
                destination_x..start_x - 1
              else
                start_x + 1..destination_x
              end
      board[range].filter { _1.is_a? Symbol }.all?(:empty)
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
              ((y < (board[x].length - 1)) && board[x][(y + 1..)].any? { |amphipod| amphipod != board[x][y] }))
        in Integer => x
          # puts "#{ x } => #{ board[x] }"
          # handle x in a hallway position
          # An amphipod in the hallway cannot move unless it has a clear shot to its room, and that room contains
          # no other type of amphipod.
          right_room = RIGHT_ROOM[board[x]]
          board[right_room].all? { |room_spot| [:empty, board[x]].include?(room_spot) } &&
            clear_path_to?(right_room, x, board)
        else
          false
      end
    end
  end
end
