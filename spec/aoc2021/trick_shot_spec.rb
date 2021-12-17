# frozen_string_literal: true

require "aoc2021/puzzles/trick_shot"

RSpec.describe AoC2021::TrickShot do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "#highest_y" do
    context "with provided input" do
      subject { AoC2021::TrickShot.new StringIO.new(<<~BITS) }
        target area: x=20..30, y=-10..-5
      BITS

      it "reaches a height of 45" do
        expect(subject.highest_y).to eq 45
      end
    end

    context "with actual input" do
      subject { AoC2021::TrickShot.new StringIO.new(<<~BITS) }
        target area: x=241..275, y=-75..-49
      BITS

      it "reaches a height of 2775" do
        expect(subject.highest_y).to eq 2775
      end
    end
  end

  describe "#find_possible_xs" do
    context "with provided input" do
      subject { AoC2021::TrickShot.new StringIO.new(<<~BITS) }
        target area: x=20..30, y=-10..-5
      BITS

      it "finds the expected possible values of x" do
        expect(subject.find_possible_xs)
          .to eq [nil, #  0
                  nil, #  1
                  nil, #  2
                  nil, #  3
                  nil, #  4
                  nil, #  5: 5 + 4 + 3 + 2 + 1 + 0 ... never reaches 20
                  [5, 6, 7, Float::INFINITY], #  6: 6 + 5 + 4 + 3 + 2 = 20 + 1 = 21 + 0 = 21 to infinity
                  [4, 5, 6, 7, 8, Float::INFINITY], #  7: 7 + 6 + 5 + 4 = 22 + 3 = 25 + 2 = 27 + 1 = 28 + 0 = 28 to infinity
                  [3, 4, 5], #  8: 8 + 7 + 6 = 21 + 5 = 26 + 4 = 30
                  [3, 4], #  9: 9 + 8 + 7 = 24 + 6 = 30
                  [3], # 10: 10 + 9 + 8 = 27
                  [2, 3], # 11: 11 + 10 = 21 + 9 = 30
                  [2], # 12: 12 + 11 = 23
                  [2], # 13: 13 + 12 = 25
                  [2], # 14: 14 + 13 = 27
                  [2], # 15: 15 + 14 = 29
                  nil, # 16
                  nil, # 17
                  nil, # 18
                  nil, # 19
                  [1], # 20
                  [1], # 21
                  [1], # 22
                  [1], # 23
                  [1], # 24
                  [1], # 25
                  [1], # 26
                  [1], # 27
                  [1], # 28
                  [1], # 29
                  [1]] # 30
      end
    end
  end
end
