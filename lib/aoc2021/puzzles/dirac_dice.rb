# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Image Enhancement for Day 20
  class DiracDice
    # extend Forwardable
    # def_instance_delegators "self.class", :y_step, :gauss

    def self.day21
      dirac_dice = File.open("input/day21a.txt") { |file| DiracDice.new file }
      puts "Day 21, part A: #{ dirac_dice.first300 }"
      puts "Day 21, part B: Player 1: #{ (wins = dirac_dice.dirac_to_score(3))[1] } universes, Player 2: #{ wins[2] } universes"
      puts
    end

    POS_PAT = /Player \d starting position: (\d+)/

    def initialize(file = StringIO.new(""))
      @start_positions = file.readlines(chomp: true).map { |line| POS_PAT.match(line) { |md| md[1] } }.map(&:to_i)

      @win_score = 2
      @roll_num  = 0
      @all_rolls = [1, 2, 3].repeated_permutation(3)
                            .map(&:sum)
                            .reduce(Hash.new { |hash, key| hash[key] = 0 }) { |acc, sum| acc.merge(sum => (1 + acc[sum])) }
    end

    def next_roll = @roll_num += 1

    def first300
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
          # puts "Player 1 rolls #{ rolls.map(&:to_s).join("+") } and moves to space #{ player1_pos } for a total score of #{ active_player_new_score } after #{ @roll_num } total rolls"
        else
          player2_pos   = (player2_pos + move_total_squares) % 10
          player2_pos   = 10 if player2_pos.zero?
          player2_score += player2_pos
          # puts "Player 2 rolls #{ rolls.map(&:to_s).join("+") } and moves to space #{ player2_pos } for a total score of #{ player2_score } after #{ @roll_num } total rolls"
        end

        player1s_turn = !player1s_turn
      end

      losing_score = player2_score >= 1000 ? player1_score : player2_score
      # puts "The losing player had a score of #{ losing_score } when the game ended after #{ @roll_num } rolls."
      "#{ losing_score } * #{ @roll_num } = #{ losing_score * @roll_num }"
    end

    def dirac_to_score(win_score = 2)
      @win_score = win_score
      roll_one_move(*@start_positions, 0, 0, true, [nil, 0, 0])
    end

    private

    def roll_one_move(player1_pos, player2_pos, player1_score, player2_score, player1s_turn, wins, weight_so_far = 1)
      @all_rolls.each do |roll_sum, weight|
        if player1s_turn
          active_player_pos       = player1_pos
          active_player_score     = player1_score
          active_player_new_pos   = ((active_player_pos + roll_sum - 1) % 10) + 1
          active_player_new_score = active_player_score + active_player_new_pos
          if active_player_new_score >= @win_score
            wins[1] += weight * weight_so_far
          else
            wins = roll_one_move(active_player_new_pos, player2_pos, active_player_new_score, player2_score, false, wins,
                                 weight * weight_so_far)
          end
        else
          active_player_pos       = player2_pos
          active_player_score     = player2_score
          active_player_new_pos   = ((active_player_pos + roll_sum - 1) % 10) + 1
          active_player_new_score = active_player_score + active_player_new_pos
          if active_player_new_score >= @win_score
            wins[2] += weight * weight_so_far
          else
            wins = roll_one_move(player1_pos, active_player_new_pos, player1_score, active_player_new_score, true, wins,
                                 weight * weight_so_far)
          end
        end
      end
      wins
    end
  end
end
