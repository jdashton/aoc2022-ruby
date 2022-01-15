# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Image Enhancement for Day 20
  class DiracDice
    def self.day21
      dirac_dice = File.open("input/day21a.txt") { |file| DiracDice.new file }
      puts "Day 21, part A: #{ dirac_dice.deterministic_die }"
      puts "Day 21, part B: Player 1: #{ (wins = dirac_dice.dirac_to_score(21))[0] } universes, Player 2: #{ wins[1] } universes"
      puts
    end

    # Encapsulates player state
    class Player
      attr_reader :score, :position

      def initialize(position, score = 0)
        @position = position - 1
        @score    = score
      end

      def advance(rolls)
        @position = (@position + rolls) % 10
        @score    += @position + 1
      end

      def position_adjusted = @position + 1

      def inspect = "Player { position: #{ @position }, score: #{ @score } }"

      def to_s = inspect
    end

    # Encapsulates packing and unpacking of game state
    class State
      attr_reader :player1, :player2

      def initialize(player1, player2)
        if player2
          @player1 = player1
          @player2 = player2
        else
          @player1, @player2 = unpack(player1)
        end
      end

      def pack
        ((((@player1.score * 10) + @player1.position) & 0xff) << 8) |
          (((@player2.score * 10) + @player2.position) & 0xff)
      end

      def self.unpack(packed_state)
        player1 = (packed_state >> 8) & 0xff
        player2 = (packed_state & 0xff)
        State.new(Player.new((player1 % 10) + 1, player1 / 10), Player.new((player2 % 10) + 1, player2 / 10))
      end

      def inspect = "State: player1=(#{ @player1.inspect }), player2=(#{ @player2.inspect })"
    end

    POS_PAT = /Player \d starting position: (\d+)/

    def initialize(file = StringIO.new(""))
      @start_positions = file.readlines(chomp: true)
                             .map { POS_PAT.match(_1) { |md| md[1] } }
                             .map(&:to_i)

      @roll_num = 0
    end

    def next_roll = @roll_num += 1

    def deterministic_die
      player1_score = player2_score = 0

      player1_pos   = 9 # 4
      player2_pos   = 3 # 8
      player1s_turn = true
      while player1_score < 1000 && player2_score < 1000
        rolls              = (1..3).map { |_| next_roll % 100 }
        move_total_squares = rolls.sum
        if player1s_turn
          player1_pos   = (player1_pos + move_total_squares) % 10
          player1_pos   = 10 if player1_pos.zero?
          player1_score += player1_pos
        else
          player2_pos   = (player2_pos + move_total_squares) % 10
          player2_pos   = 10 if player2_pos.zero?
          player2_score += player2_pos
        end

        player1s_turn = !player1s_turn
      end

      losing_score = player2_score >= 1000 ? player1_score : player2_score
      "#{ losing_score } * #{ @roll_num } = #{ losing_score * @roll_num }"
    end

    # {3=>1, 4=>3, 5=>6, 6=>7, 7=>6, 8=>3, 9=>1}
    ALL_ROLLS = [1, 2, 3].repeated_permutation(3)
                         .map(&:sum)
                         .reduce(Hash.new { |hash, key| hash[key] = 0 }) { |acc, sum| acc.merge(sum => (1 + acc[sum])) }

    # This implementation based directly on the work of Simon Gomizelj (vodik on Github)
    def dirac_to_score(win_score = 2)
      counter = Array.new(57314, 0)

      wins1 = wins2 = 0

      counter[State.new(Player.new(@start_positions.first), Player.new(@start_positions.last)).pack] = 1

      loop do
        dirty        = false
        next_counter = Array.new(57314, 0)

        counter.each_with_index do |state_qty, packed_state|
          next unless state_qty > 0

          state = State.unpack(packed_state)

          ALL_ROLLS.each do |p1_roll, p1_qty|
            p1_hits = state_qty * p1_qty
            player1 = state.player1.dup
            player1.advance(p1_roll)

            if player1.score >= win_score
              wins1 += p1_hits
              next
            end

            ALL_ROLLS.each do |p2_roll, p2_qty|
              p2_hits = p1_hits * p2_qty
              player2 = state.player2.dup
              player2.advance(p2_roll)

              if player2.score >= win_score
                wins2 += p2_hits
                next
              end

              pack               = State.new(player1, player2).pack
              next_counter[pack] += p2_hits
              dirty              = true
            end
          end
        end

        break [wins1, wins2] unless dirty

        counter = next_counter
      end
    end

    def self.parse_position(line)
      POS_PAT.match(line) { |md| md[1] }
    end
  end
end
