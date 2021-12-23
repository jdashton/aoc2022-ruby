# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Image Enhancement for Day 20
  class DiracDice
    extend Forwardable
    def_instance_delegators "self.class", :parse_position, :calculate_new_pos_score_weight

    def self.day21
      dirac_dice = File.open("input/day21a.txt") { |file| DiracDice.new file }
      puts "Day 21, part A: #{ dirac_dice.deterministic_die }"
      puts "Day 21, part B: Player 1: #{ (wins = dirac_dice.dirac_to_score(3))[0] } universes, Player 2: #{ wins[1] } universes"
      puts
    end

    POS_PAT = /Player \d starting position: (\d+)/

    def initialize(file = StringIO.new(""))
      @start_positions = file.readlines(chomp: true).map(&method(:parse_position)).map(&:to_i)

      @win_score = 2
      @roll_num  = 0
      @all_rolls = [1, 2, 3].repeated_permutation(3)
                            .map(&:sum)
                            .reduce(Hash.new { |hash, key| hash[key] = 0 }) { |acc, sum| acc.merge(sum => (1 + acc[sum])) }
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
      # puts "The losing player had a score of #{ losing_score } when the game ended after #{ @roll_num } rolls."
      "#{ losing_score } * #{ @roll_num } = #{ losing_score * @roll_num }"
    end

    def dirac_to_score(win_score = 2)
      @win_score = win_score
      roll_one_move(*@start_positions, 0, 0, [0, 0], 1, 0)
    end

    def self.parse_position(line)
      POS_PAT.match(line) { |md| md[1] }
    end

    def self.calculate_new_pos_score_weight(active_player_pos, active_player_score, roll_data, weight_so_far)
      roll_sum, weight        = roll_data
      active_player_new_pos   = ((active_player_pos + roll_sum - 1) % 10) + 1
      active_player_new_score = active_player_score + active_player_new_pos
      weight_product          = weight * weight_so_far
      [active_player_new_pos, active_player_new_score, weight_product]
    end

    private

    def roll_one_move(active_player_pos, other_player_pos, active_player_score, other_player_score, wins,
                      weight_so_far, player_num)
      @all_rolls.reduce(0) do |_, roll_data|
        active_player_new_pos, active_player_new_score, weight_product = calculate_new_pos_score_weight(active_player_pos,
                                                                                                        active_player_score,
                                                                                                        roll_data,
                                                                                                        weight_so_far)
        if active_player_new_score >= @win_score
          wins.fill(wins[player_num] + weight_product, player_num, 1) # A form of assignment that returns self
        else
          roll_one_move(other_player_pos, active_player_new_pos, other_player_score, active_player_new_score, wins,
                        weight_product, (player_num + 1) % 2)
        end
      end
    end
  end
end
