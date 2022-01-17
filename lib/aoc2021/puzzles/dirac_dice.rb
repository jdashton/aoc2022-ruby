# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Image Enhancement for Day 20
  class DiracDice
    def self.day21
      dirac_dice = File.open("input/day21a.txt") { |file| DiracDice.new file }
      puts "Day 21, part A: #{ dirac_dice.deterministic_die }"
      puts "Day 21, part B: Player 1: #{ (wins = dirac_dice.dirac_to_score)[0] } universes, Player 2: #{ wins[1] } universes"
      puts
    end

    # Encapsulates player state
    class Player
      attr_reader :score, :position

      def initialize(position, score = 0)
        if position
          @position = position - 1
          @score    = score
        else
          @position = score % 10
          @score    = score / 10
        end
      end

      def advance(rolls)
        @position = (@position + rolls) % 10
        @score    += @position + 1
        self
      end

      def pack = (@score * 10) + @position

      # only used in tests
      def position_adjusted = @position + 1

      def inspect = "Player { position: #{ @position }, score: #{ @score } }"

      def to_s = inspect
    end

    # Encapsulates packing and unpacking of game state
    module State
      def self.pack(player1, player2) = (player1.pack << 8) | player2.pack

      def self.unpack(packed_state) = [Player.new(nil, packed_state >> 8), Player.new(nil, packed_state & 0xff)]
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

      player1_pos, player2_pos = @start_positions

      player1s_turn = true
      while player1_score < 1000 && player2_score < 1000
        move_total_squares = (1..3).map { next_roll % 100 }.sum
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
    def dirac_to_score(win_score = 21)
      DiracDice.const_set("WINNING_SCORE", win_score)
      cache = Ractor.new do
        che = Array.new(57_314)
        loop do
          msg, state, obj = Ractor.receive
          case msg
            when :cache
              che[state] = obj
            when :read
              obj.send che[state]
          end
        end
      end
      DiracDice.const_set("CACHE", cache)
      [ALL_ROLLS, WINNING_SCORE, CACHE].each { Ractor.make_shareable _1 }

      wins1   = wins2 = 0
      ractors = []

      p1_start_pos, p2_start_pos = @start_positions.map { _1 - 1 }

      ALL_ROLLS.each do |p1_roll, p1_hits|
        p1_pos   = (p1_start_pos + p1_roll) % 10
        p1_score = p1_pos + 1
        next wins1 += p1_hits if p1_score >= WINNING_SCORE

        ALL_ROLLS.each do |p2_roll, p2_qty|
          p2_pos   = (p2_start_pos + p2_roll) % 10
          p2_score = p2_pos + 1
          p2_hits  = p1_hits * p2_qty
          next wins2 += p2_hits if p2_score >= WINNING_SCORE

          ractors << Ractor.new(p1_pos, p1_score, p2_pos, p2_score, p2_hits, &method(:seven_rolls))
        end
      end

      ractors.reduce([wins1, wins2]) do |acc, ractor|
        unv_a, unv_b = ractor.take
        [acc[0] + unv_a, acc[1] + unv_b]
      end
    end

    def seven_rolls(player_pos, player_score, other_player_pos, other_player_score, quantity)
      packed_state = (((player_score * 10) + player_pos) << 8) | ((other_player_score * 10) + other_player_pos)
      CACHE.send [:read, packed_state, Ractor.current]
      answer = Ractor.receive
      return [answer[0] * quantity, answer[1] * quantity] if answer

      wins_a = wins_b = 0
      ALL_ROLLS.each do |roll, qty|
        new_position = (player_pos + roll) % 10
        new_score    = player_score + new_position + 1
        next wins_a += qty if new_score >= WINNING_SCORE

        # recursive call (swapping current with other) and swap returned score
        unv_a, unv_b = seven_rolls(other_player_pos, other_player_score, new_position, new_score, qty)
        wins_a       += unv_b
        wins_b       += unv_a
      end
      CACHE.send [:cache, packed_state, [wins_a, wins_b]]
      [wins_a * quantity, wins_b * quantity]
    end

    def try_all_starting_positions
      [*1..10].repeated_permutation(2).each do |starts|
        @start_positions = starts
        print_summary(dirac_to_score(21), starts)
      end
    end

    private

    def print_summary(scores, starts)
      sum                            = scores.sum
      player_1_score, player_2_score = scores
      puts "#{ starts } favors player #{ player_1_score > player_2_score ? 1 : 2 }\t(#{ scores })\t" \
           "#{ (player_1_score.to_f / sum * 100).round(0) }% vs #{ (player_2_score.to_f / sum * 100).round(0) }%"
    end
  end
end
