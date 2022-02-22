# frozen_string_literal: true

require "set"

module AoC2021
  # Calculates conditions of victory for given moves and boards
  module Amphipod
    def self.day23
      board = File.open("input/day23a.txt") { |file| Amphipod.parse_board file }
      # puts "Day 23, part A: #{ Move.new(amphipod.board).play_game(PriorityQueue.new) } is the least energy required to organize the amphipods."
      # puts "Day 23, part B: #{ amphipod.least_energy_unfolded }  is the least energy required to organize all the amphipods."
      puts
    end

    # Encapsulate a board, a score and history
    class Move
      attr_reader :board, :score, :history

      def initialize(board, score = 0, history = nil)
        @board   = board.respond_to?(:fileno) ? Amphipod.parse_board(board) : board
        @score   = score
        @history = history
        # pp @board; exit
      end

      def play_game(queue)
        move  = self
        count = 0

        loop do
          queue.concat move.next_moves
          move = queue.next

          # print "Considering board "
          # pp next_board
          count += 1
          puts "#{ count }...#{ move.score }" if (count % 10_000).zero?

          next unless move.final_state?

          puts "final state: #{ score = move.score } after #{ count } moves"
          move.print_history
          return score
        end
      end

      def print_history
        brd = @board
        pp board
        puts "  #{ brd[0] || "." }#{ brd[1] || "." }.#{ brd[3] || "." }.#{ brd[5] || "." }.#{ brd[7] || "." }.#{ brd[9] || "." }#{ brd[10] || "." }"
        brd[2].each_index do |i|
          puts "    #{ brd[2][i] || "." } #{ brd[4][i] || "." } #{ brd[6][i] || "." } #{ brd[8][i] || "." }"
        end
        puts ("-" * 15) + " #{ @score }"
        @history&.print_history
      end

      def final_state?
        @board.values_at(*HALL_SPOTS).all?(nil) &&
          @board.values_at(*ROOMS).zip(ROOMS).all? { |(room, num)| room.all?(ROOM_AMPHIPOD[num]) }
      end

      def next_moves
        # pp @board, ready_to_move
        Set.new(ready_to_move.reduce([]) do |acc, pos|
          # pp @board, pos
          case pos
            in [room, room_spot]
              # puts "Looking for moves for #{ board[x][y] } at #{ x }, #{ y }"
              hall_list = hall_avail(room, room_spot)
              room_list = room_avail(room, room_spot)
              acc + hall_list + room_list
            in hall_spot
              # puts "Looking for moves for #{ @board[x] } at #{ x }"
              # An amphipod in the hallway can only move into the last available :empty position in the right room.
              # Return the board transformed in this way.
              amphipod             = @board[hall_spot]
              new_board            = @board.map(&:clone)
              new_board[hall_spot] = nil
              room_num             = RIGHT_ROOM[amphipod]
              room                 = new_board[room_num]
              new_y                = room.rindex(nil)
              pp room, @board if new_y.nil?
              room[new_y] = amphipod
              acc << Move.new(new_board, @score + (Move.distance(hall_spot, room_num, new_y) * COSTS[amphipod]), self)
            else
              raise "Unexpected branch"
          end
        end)
      end

      def hall_avail(old_room, room_spot)
        amphipod = @board[old_room][room_spot]
        HALL_SPOTS.filter { |hall_spot| clear_path_to?(hall_spot, old_room) }
                  .reduce([]) do |acc, hall_spot|
          new_board                      = @board.map(&:clone)
          new_board[hall_spot]           = amphipod
          new_board[old_room][room_spot] = nil
          # print "found "
          # pp [new_board, @score + (Move.distance(hall_spot, room, room_spot) * COSTS[amphipod])]
          acc << Move.new(new_board, @score + (Move.distance(hall_spot, old_room, room_spot) * COSTS[amphipod]), self)
        end
      end

      def room_avail(old_room, old_room_spot)
        # print_history
        amphipod   = @board[old_room][old_room_spot]
        right_room = RIGHT_ROOM[amphipod]
        return [] unless @board[right_room].all? do |room_spot|
          [nil, amphipod].include?(room_spot)
        end && clear_path_to?(right_room, old_room)

        new_board                            = @board.map(&:clone)
        new_room_spot                        = @board[right_room].rindex(nil)
        new_board[right_room][new_room_spot] = amphipod
        new_board[old_room][old_room_spot]   = nil
        # print "found "
        # pp [new_board, @score + (Move.distance(right_room, old_room, old_room_spot + new_room_spot + 1) * COSTS[amphipod])]
        [
          Move.new(new_board,
                   @score + (Move.distance(right_room, old_room, old_room_spot + new_room_spot + 1) * COSTS[amphipod]),
                   self)
        ]
      end

      def self.distance(x, room, y)
        (room - x).abs + 1 + y
      end

      # Returns a list of pieces that can make at least one valid move.
      def ready_to_move
        @board.each_with_index.map { |thing_at_pos, x|
          case thing_at_pos
            in AMPHIPODS
              can_move_to_room?(x) ? x : nil
            in Array => room
              y = room.each_index.find { room[_1] } # != nil
              y && (can_move_from_room_spot?(x, y) ? [x, y] : nil)
            else
              nil
          end
        }.compact
      end

      def can_move_to_room?(hall_spot)
        # puts "#{ x } => #{ board[x] }"
        # handle x in a hallway position
        # An amphipod in the hallway cannot move unless it has a clear shot to its room, and that room contains
        # no other type of amphipod.
        amphipod   = @board[hall_spot]
        right_room = RIGHT_ROOM[amphipod]
        @board[right_room].all? { |room_spot| [nil, amphipod].include?(room_spot) } &&
          clear_path_to?(right_room, hall_spot)
      end

      def can_move_from_room_spot?(room_num, spot)
        # puts "#{ x }, #{ y } => #{ board[x][y] }"
        # handle [x, y] in a room
        # In all cases, if x - 1 is not :empty AND x + 1 is not :empty, this piece cannot move.
        current_room = @board[room_num]
        amphipod     = current_room[spot]
        @board[(room_num - 1..room_num + 1).step(2)].any?(nil) &&
          # y must have no other pieces with a lower index  [:empty, :empty, :D, :A] the :D can move
          (spot.zero? || current_room[..spot - 1].all?(nil)) &&
          # and must be in the wrong room OR
          (RIGHT_ROOM[amphipod] != room_num ||
            # be followed by a different piece [:empty, :empty, :D, :A] the :D can move even if it is in the :D (x = 8) room
            ((spot < (current_room.length - 1)) && current_room[(spot + 1..)].any? { |denizen| denizen != amphipod }))
      end

      # Returns true/false whether a piece can move from start_x to destination_x.
      def clear_path_to?(destination_x, start_x)
        range = if destination_x < start_x
                  destination_x..start_x - 1
                else
                  start_x + 1..destination_x
                end
        @board[range].filter { _1.is_a? Symbol }.all?(nil)
      end

      def hash = [@board, @score].hash

      def eql?(other) = @board == other.board && @score == other.score
    end

    # Encapsulates methods for a Room
    class Room
      attr_reader :room

      def initialize(room)
        @room = room
      end

      def extract
        @room.first
      end

      def take
        @room.shift
      end

      def empty?
        @room.empty?
      end
    end

    # Encapsulates methods pertaining to a Burrow
    class Burrow
      attr_reader :board

      def initialize(board)
        @board = board.respond_to?(:fileno) ? Amphipod.parse_board(board) : board
      end

      def inspect
        "Burrow: @board=#{ @board.inspect }"
      end

      def clone
        @board.map(&:clone)
      end

      def play_vodik(_queue)
        prune
        entry_energy + exit_energy + solve
      end

      def entry_energy
        ROOMS.reduce(0) { |acc, room_num| acc + ((1..@board[room_num].length).sum * COSTS[ROOM_AMPHIPOD[room_num]]) }
      end

      def exit_energy
        ROOMS.reduce(0) do |acc, room_num|
          acc + @board[room_num].each_with_index.reduce(0) { |acm, (pod, idx)| acm + (COSTS[pod] * (1 + idx)) }
        end
      end

      # Used for testing
      def head_prune
        ROOMS.each { @board[_1].shift while !@board[_1].empty? && @board[_1].first.nil? }
        self
      end

      def prune
        ROOMS.each { @board[_1].pop while @board[_1].last == ROOM_AMPHIPOD[_1] }
        self
      end

      def hallway_empty?
        @board.reject { _1.is_a? Array }.compact.empty?
      end

      TYPES     = { A: "Amber", B: "Bronze", C: "Copper", D: "Desert" }.freeze
      ROOM_NUMS = { 0 => 64, 1 => 32, 3 => 16, 5 => 8, 7 => 4, 9 => 2, 10 => 1, nil => 0 }.freeze

      # In Simon's bitboard implementation, mask is a 7-bit representation
      # of the hallway, where 64 is the leftmost spot and 1 is the rightmost.
      # For the moment, our hallway has spots 0, 1, 3, 5, 7, 9, and 10.
      # Switching to the bitboard might perform better.
      def commit(from_room, hall_pos)
        pod = @board[from_room].shift
        @board[hall_pos] = pod if hall_pos # might be nil, indicating that this pod goes into its room

        # target below is the from_room parameter, and
        # mask below is the hall_pos param
        #         match pod {
        #             Amphipod::Amber => {
        #                 self.rooms[target].take();
        #                 self.hallway.amber |= mask;
        #             }
        #             Amphipod::Bronze => {
        #                 self.rooms[target].take();
        #                 self.hallway.bronze |= mask;
        #             }
        #             Amphipod::Copper => {
        #                 self.rooms[target].take();
        #                 self.hallway.copper |= mask;
        #             }
        #             Amphipod::Desert => {
        #                 self.rooms[target].take();
        #                 self.hallway.desert |= mask;
        #             }
        #         }
        #
        #         if self.rooms[0].is_empty() {
        #             self.hallway.amber = 0;
        #         }
        #         if self.rooms[1].is_empty() {
        #             self.hallway.bronze = 0;
        #         }
        #         if self.rooms[2].is_empty() {
        #             self.hallway.copper = 0;
        #         }
        #         if self.rooms[3].is_empty() {
        #             self.hallway.desert = 0;
        #         }
        8.step(by: -2, to: 2).each do |room|
          if @board[room].empty?
            amph   = ROOM_AMPHIPOD[room]
            @board = @board.map { |spot| spot == amph ? nil : spot }
          end
        end
      end

      # Focused on detecting a clear path between rooms 2, 4, 6, and 8
      # Always pass in the left room number as start_pos, and the number
      # of steps to check (2, 4, or 6) as dist.
      def has_path?(start_pos, dist)
        return true if dist.zero?

        # let mask = ((2 << (dist - 1)) - 1) << (5 - dist - start);
        # self.hallway.flatten() & mask == 0
        board[(start_pos + 1...start_pos + dist).step(2)].compact.empty?
      end

      HALL_COSTS = [2, 2, nil, 4, nil, 4, nil, 4, nil, 2, 2].freeze
      # returns something like [(32, 8), (64, 10), (2, 8), (1, 10)] where the first
      # element of each tuple is the hallway position, and the second element is the cost.
      def moves(room)
        # pos below is the room parameter
        #         let pod = self.rooms[pos].extract()?;
        pod = @board[room].first
        return nil unless pod
        #
        #         let energy = pod.energy();
        energy = COSTS[pod]
        #         let target = match pod {
        #             Amphipod::Amber => 0,
        #             Amphipod::Bronze => 1,
        #             Amphipod::Copper => 2,
        #             Amphipod::Desert => 3,
        #         };
        right_room = RIGHT_ROOM[pod]
        #
        #         const COSTS: [usize; 7] = [2, 2, 4, 4, 4, 2, 2];
        #         let hallway = self.hallway.flatten();
        #         let mut moves = Vec::with_capacity(7);
        moves = []
        #
        #         let (start, end) = if pos < target {
        #             (pos, target)
        #         } else {
        #             (target, pos)
        #         };
        start_pos, end_pos = [room, right_room].minmax
        #
        #         let dist = end - start;
        dist = end_pos - start_pos
        #         let basecost = dist * 2;
        base_cost = dist * 2
        #         let has_path = self.has_path(start, dist);
        has_path = has_path?(start_pos, dist)
        #
        #         if has_path && self.rooms[target].is_empty() {
        if has_path && @board[right_room].compact.empty?
          #             moves.push((0, base_cost * energy));
          moves << ([nil, dist * energy]) # [nil indicates that no hallway position will be occupied.
          #         } else {
        else
          #             if has_path || pos < target {
          if has_path || room < right_room
            #                 moves.extend(
            #                     (0..start + 2) # the +2 is because start is in terms of rooms, which are 0 to 3
            #                         .rev()
            #                         .map(|offset| (1 << (6 - offset), COSTS[offset]))
            #                         .scan(0, |acc, (mask2, weight)| {
            acc = 0
            (0...start_pos)
              .reverse_each
              .map { |offset| [offset, HALL_COSTS[offset]] }
              .each { |hall_spot, weight|
                next unless weight
                break if @board[hall_spot]

                cost = acc.zero? ? 2 : acc + weight
                acc  += weight
                moves << [hall_spot, (dist + cost) * energy]
              }
          end
          #                             let cost = if *acc == 0 {
          #                                 *acc += weight;
          #                                 2
          #                             } else {
          #                                 *acc += weight;
          #                                 *acc
          #                             };
          #
          #                             (mask2 & hallway == 0).then(|| (mask2, (basecost + cost) * energy))
          #                         }),
          #                 );
          #             }

          #
          #             if has_path || target < pos {
          if has_path || right_room < room
            acc = 0
            (end_pos + 1...11)
              .map { |offset| [offset, HALL_COSTS[offset]] }
              .each { |hall_spot, weight|
                next unless weight
                break if @board[hall_spot]

                cost = acc.zero? ? 2 : acc + weight
                acc  += weight
                moves << [hall_spot, (dist + cost) * energy]
              }
            #                 moves.extend(
            #                     (end + 2..7)
            #                         .map(|offset| (1 << (6 - offset), COSTS[offset]))
            #                         .scan(0, |acc, (mask2, weight)| {
            #                             let cost = if *acc == 0 {
            #                                 *acc += weight;
            #                                 2
            #                             } else {
            #                                 *acc += weight;
            #                                 *acc
            #                             };
            #
            #                             (mask2 & hallway == 0).then(|| (mask2, (basecost + cost) * energy))
            #                         }),
            #                 );
          end
          #             }
        end
        #         }
        #
        #         Some((*pod, pos, moves))
        puts "hallway: #{ @board
                            .reject { _1.is_a? Array }
                            .reverse
                            .each_with_index
                            .map { |amph, idx| amph ? (1 << idx) : 0}
                            .reduce(:|) }"
        [pod, room, moves]
        #     }
      end

      def solve
        # pp @board

        #     let mut stack = vec![(Burrow::<N>::new(rooms), 0)];  Returns a vector of (Burrow, cost) tuples.
        # ##    [(Burrow {
        #           rooms: [
        #             Room { slots: [Some(Amber),  Some(Desert)], pos: 0 },
        #             Room { slots: [Some(Copper), Some(Desert)], pos: 0 },
        #             Room { slots: [Some(Bronze), Some(Bronze)], pos: 0 },
        #             Room { slots: [Some(Amber),  Some(Copper)], pos: 0 }
        #           ],
        #           hallway: BitBoard { amber: 0, bronze: 0, copper: 0, desert: 0 }
        #         },
        #         0)]    this is the cost (already incurred?)
        #     let mut min = usize::MAX;  (Essentially Float::INFINITY)
        stack = [[self, 0]]
        min   = Float::INFINITY
        min   = 18446744073709551615

        #
        #     while let Some((burrow, cost)) = stack.pop() {
        while (current_burrow, current_cost = stack.pop)
          # pp current_burrow, current_cost
          puts "popped a new burrow: #{ current_burrow.inspect }, #{ current_cost }"

          #         for t in (0..4).rev() {  (.. is non-inclusive, so start with room[3] and work down to room[0])
          8.step(by: -2, to: 2) do |t|
            # pp t

            #             if let Some((pod, target, futures)) = burrow.moves(t) {
            next unless (pod, target, futures = current_burrow.moves(t))

            puts "(#{ TYPES[pod] }, #{ target / 2 - 1 }, [#{ futures
                                                               .map { |room, cost| "(#{ROOM_NUMS[room]}, #{cost})" }
                                                               .join(", ") }])"
            #                      ## (Amber, 3, [(32, 8), (64, 10), (2, 8), (1, 10)])
            #                 for future in futures {
            futures.each do |future|
              #                     let mut burrow = burrow;
              burrow = Burrow.new(current_burrow.clone)
              #                     let cost = cost + future.1;
              cost = current_cost + future[1]
              #                     if cost < min {
              next unless cost < min

              puts "#{ cost } < #{ min }"
              #                         burrow.commit(pod, target, future.0);
              burrow.commit(target, future[0])
              #
              #                         if burrow.hallway.is_empty() {
              if burrow.hallway_empty?
                #                             min = cost;
                min = cost
                #                         } else {
              else
                #                             stack.push((burrow, cost));
                stack.push [burrow, cost]
                #                         }
              end
              #                     }
              #                 }
            end
            #             }
            #         }
          end
          #     }
        end
        #
        #     min

        # 6_268
        puts "Returning a min cost of #{ min }"
        min
      end
    end

    attr_reader :board

    def self.parse_board(file)
      lines = file.readlines(chomp: true)
      board = Array.new(11)
      /#([A-D.])([A-D.])\.([A-D.])\.([A-D.])\.([A-D.])\.([A-D.])([A-D.])#/.match(lines[1]) do |md|
        board[0]  = md[1].to_sym
        board[1]  = md[2].to_sym
        board[3]  = md[3].to_sym
        board[5]  = md[4].to_sym
        board[7]  = md[5].to_sym
        board[9]  = md[6].to_sym
        board[10] = md[7].to_sym
      end
      HALL_SPOTS.each { |spot| board[spot] = nil if board[spot] == :"." }
      ROOMS.each { |room_num| board[room_num] = [] }
      (0..3).each do |room_spot|
        /#+([A-D.])#([A-D.])#([A-D.])#([A-D.])#+/.match(lines[room_spot + 2]) do |md|
          board[2][room_spot] = (md[1].to_sym in AMPHIPODS) ? md[1].to_sym : nil
          board[4][room_spot] = (md[2].to_sym in AMPHIPODS) ? md[2].to_sym : nil
          board[6][room_spot] = (md[3].to_sym in AMPHIPODS) ? md[3].to_sym : nil
          board[8][room_spot] = (md[4].to_sym in AMPHIPODS) ? md[4].to_sym : nil
        end
      end
      board
    end

    COSTS = { A: 1, B: 10, C: 100, D: 1000 }.freeze

    HALL_SPOTS = [0, 1, 3, 5, 7, 9, 10].freeze

    AMPHIPODS = Set[*%i[A B C D]]

    RIGHT_ROOM    = { A: 2, B: 4, C: 6, D: 8 }.freeze
    ROOM_AMPHIPOD = RIGHT_ROOM.invert

    ROOMS = Set[2, 4, 6, 8]
  end
end
