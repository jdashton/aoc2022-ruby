# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 2, we're playing Rock-Paper-Scissors.
    class RockPaperScissors
      def self.day02
        game = File.open('input/day02.txt') { |file| RockPaperScissors.new file }
        puts "Day  2, Part One: the score will be #{ game.guide_alpha } if everything goes according to the strategy guide."
        puts "Day  2, Part Two: the score will be #{ game.guide_beta } if everything goes according to the strategy guide."
        puts
      end

      # A, B, C is what the opponent chooses,
      # X, Y, Z is what you play.

      # A, X - Rock - 1 point to play
      # B, Y - Paper - 2 points
      # C, Z - Scissors - 3 points

      # lose - 0 points
      # draw - 3 points
      # win - 6 points

      # Scoring: the shape you played + outcome points

      MOVE_SCORES_ALPHA = {
        'A X' => 4, # 1 + 3 = 4
        'A Y' => 8, # Paper (Y) beats Rock (A) for 2 + 6 = 8 points
        'A Z' => 3, # 3 + 0 = 3
        'B X' => 1, # Paper (B) beats Rock (X) for 1 + 0 = 1 point
        'B Y' => 5, # 2 + 3 = 5
        'B Z' => 9, # 3 + 6 = 9
        'C X' => 7, # 1 + 6 = 7
        'C Y' => 2, # 2 + 0 = 2
        'C Z' => 6 # Scissors (C) is a draw with Scissors (Z) for 3 + 3 = 6 points
      }.freeze

      # Revised info:
      # X means you should lose
      # Y means you should draw
      # Z means you should win

      MOVE_SCORES_BETA = {
        'A X' => 3, # Play scissors (3) and lose (0)
        'A Y' => 4, # Play rock (1) and draw (3)
        'A Z' => 8, # Play paper (2) and win (6)
        'B X' => 1, # Play rock (1) and lose (0)
        'B Y' => 5, # Play paper (2) and draw (3)
        'B Z' => 9, # Play scissors (3) and win (6)
        'C X' => 2, # Play paper (2) and lose (0)
        'C Y' => 6, # Play scissors (3) and draw (3)
        'C Z' => 7 # Play rock (1) and win (6)
      }.freeze

      def initialize(file)
        @moves = file.readlines(chomp: true)
      end

      def guide_alpha
        @moves.map { |move| MOVE_SCORES_ALPHA[move] }.sum
      end

      def guide_beta
        @moves.map { |move| MOVE_SCORES_BETA[move] }.sum
      end
    end
  end
end
