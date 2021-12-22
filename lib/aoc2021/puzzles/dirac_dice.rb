# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Image Enhancement for Day 20
  class DiracDice
    # extend Forwardable
    # def_instance_delegators "self.class", :y_step, :gauss

    def self.day21
      dirac_dice = File.open("input/day21a.txt") { |file| DiracDice.new file }
      print "Day 21, part A: "
      dirac_dice.first300
      # print "Day 21, part B: "
      # puts "#{dirac_dice.dirac_to_score(21)} "
      puts
    end

    def initialize(file = StringIO.new(""))
      @lines = file.readlines(chomp: true)

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
          # puts "Player 1 rolls #{ rolls.map(&:to_s).join("+") } and moves to space #{ player1_pos } for a total score of #{ player1_score_ } after #{ @roll_num } total rolls"
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
      puts "#{ losing_score } * #{ @roll_num } = #{ losing_score * @roll_num }"
    end

    def dirac_to_score(win_score = 2)
      @win_score = win_score
      # wins       = roll_one_move 4, 8, 0, 0, true, [nil, 0, 0]  # with the given example
      wins       = roll_one_move 9, 3, 0, 0, true, [nil, 0, 0]    # my puzzle input
      puts "Player 1: #{ wins[1] } universes"
      puts "Player 2: #{ wins[2] } universes"
      wins
    end

    private

    def roll_one_move(player1_pos, player2_pos, player1_score, player2_score, player1s_turn, wins, weight_so_far = 1)
      @all_rolls.each do |roll_sum, weight|
        if player1s_turn
          player1_pos_   = ((player1_pos + roll_sum - 1) % 10) + 1
          player1_score_ = player1_score + player1_pos_
          # puts "P1 rolls #{ roll_sum }, moves fr #{ player1_pos } to #{ player1_pos_ }, score now #{ player1_score_ } wt #{ weight }"
          if player1_score_ >= @win_score
            wins[1] += weight * weight_so_far
          else
            wins = roll_one_move(player1_pos_, player2_pos, player1_score_, player2_score, false, wins, weight * weight_so_far)
          end
        else
          player2_pos_   = ((player2_pos + roll_sum - 1) % 10) + 1
          player2_score_ = player2_score + player2_pos_
          # puts "  P2 rolls #{ roll_sum }, moves fr #{ player2_pos } to #{ player2_pos_ }, score now #{ player2_score_ } wt #{ weight }"
          if player2_score_ >= @win_score
            wins[2] += weight * weight_so_far
          else
            wins = roll_one_move(player1_pos, player2_pos_, player1_score, player2_score_, true, wins, weight * weight_so_far)
          end
        end
      end
      wins
    end
  end
end
