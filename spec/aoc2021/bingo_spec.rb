# frozen_string_literal: true

require "aoc2021/puzzles/bingo"

RSpec.describe AoC2021::Bingo do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "#victory" do
    context "with provided input" do
      subject { AoC2021::Bingo.new StringIO.new(<<~BITS) }
        7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

        22 13 17 11  0
         8  2 23  4 24
        21  9 14 16  7
         6 10  3 18  5
         1 12 20 15 19

         3 15  0  2 22
         9 18 13 17  5
        19  8  7 25 23
        20 11 10 24  4
        14 21 16 12  6

        14 21 17 24  4
        10 16 15  9 19
        18  8 23 26 20
        22 11 13  6  5
         2  0 12  3  7
      BITS

      it "scores 4512" do
        expect(subject.victory).to eq 4512
      end

      it "scores 1924 on the last board to win" do
        expect(subject.last_win).to eq 1924
      end
    end
  end
end
