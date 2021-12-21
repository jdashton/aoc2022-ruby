# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Image Enhancement for Day 20
  class DiracDice
    # extend Forwardable
    # def_instance_delegators "self.class", :y_step, :gauss

    def self.day21
      dirac_dice = File.open("input/day21a.txt") { |file| DiracDice.new file }
      puts "Day 20, part A: #{ dirac_dice.lit_pixels_after(2) } pixels are lit in the resulting image."
      # puts "Day 20, part B: #{dirac_dice.permutations} "
      puts
    end

    def initialize(file = StringIO.new(""))
      @lines = file.readlines(chomp: true)

      @roll_num = 0
    end

    def next_roll = @roll_num += 1

    def first300
      player1_score = player2_score = 0

      player1_pos  = 9 # 4
      player2_pos  = 3 # 8
      turn         = 1
      while player1_score < 1000 && player2_score < 1000
        rolls              = (1..3).map { |_| next_roll % 100 }
        move_total_squares = rolls.sum
        if turn == 1
          player1_pos   = (player1_pos + move_total_squares) % 10
          player1_pos   = 10 if player1_pos.zero?
          player1_score += player1_pos
          puts "Player 1 rolls #{ rolls.map(&:to_s).join("+") } and moves to space #{ player1_pos } for a total score of #{ player1_score } after #{ @roll_num } total rolls"
        else
          player2_pos   = (player2_pos + move_total_squares) % 10
          player2_pos   = 10 if player2_pos.zero?
          player2_score += player2_pos
          puts "Player 2 rolls #{ rolls.map(&:to_s).join("+") } and moves to space #{ player2_pos } for a total score of #{ player2_score } after #{ @roll_num } total rolls"
        end
        turn               = (turn + 1) % 2
      end
      losing_score = player2_score >= 1000 ? player1_score : player2_score
      puts "The losing player had a score of #{ losing_score } when the game ended after #{ @roll_num } rolls."
      puts "Their poduct is #{ losing_score * @roll_num }."
    end
  end
end
