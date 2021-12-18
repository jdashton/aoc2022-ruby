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

  describe "#count_valid_pairs" do
    context "with provided input" do
      subject { AoC2021::TrickShot.new StringIO.new(<<~BITS) }
        target area: x=20..30, y=-10..-5
      BITS

      it "finds 112 valid velocity pairs" do
        expect(subject.count_valid_pairs).to eq 112
      end
    end
  end

  describe "#y_step" do
    context "with provided input" do
      subject { AoC2021::TrickShot.new StringIO.new(<<~BITS) }
        target area: x=20..30, y=-10..-5
      BITS

      it "find the expected steps for 9" do
        expect(subject.y_step(9, 1)).to eq 9
        expect(subject.y_step(9, 2)).to eq 17
        expect(subject.y_step(9, 3)).to eq 24
        expect(subject.y_step(9, 4)).to eq 30
        expect(subject.y_step(9, 5)).to eq 35
        expect(subject.y_step(9, 6)).to eq 39
        expect(subject.y_step(9, 7)).to eq 42
        expect(subject.y_step(9, 8)).to eq 44
        expect(subject.y_step(9, 9)).to eq 45
        expect(subject.y_step(9, 10)).to eq 45
        expect(subject.y_step(9, 11)).to eq 44
        expect(subject.y_step(9, 12)).to eq 42
        expect(subject.y_step(9, 13)).to eq 39
        expect(subject.y_step(9, 14)).to eq 35
        expect(subject.y_step(9, 15)).to eq 30
        expect(subject.y_step(9, 16)).to eq 24
        expect(subject.y_step(9, 17)).to eq 17
        expect(subject.y_step(9, 18)).to eq 9
        expect(subject.y_step(9, 19)).to eq 0
        expect(subject.y_step(9, 20)).to eq(-10)
        expect(subject.y_step(9, 21)).to eq(-21)
      end
    end
  end

  describe "#find_possible_pairs" do
    context "with provided input" do
      subject { AoC2021::TrickShot.new StringIO.new(<<~BITS) }
        target area: x=20..30, y=-10..-5
      BITS

      it "find the expected valid pairs" do
        expect(subject.find_possible_pairs(subject.find_possible_xs))
          .to eq Set[
                   [23, -10], [25, -9], [27, -5], [29, -6], [22, -6], [21, -7], [9, 0], [27, -7], [24, -5],
                   [25, -7], [26, -6], [25, -5], [6, 8], [11, -2], [20, -5], [29, -10], [6, 3], [28, -7],
                   [8, 0], [30, -6], [29, -8], [20, -10], [6, 7], [6, 4], [6, 1], [14, -4], [21, -6],
                   [26, -10], [7, -1], [7, 7], [8, -1], [21, -9], [6, 2], [20, -7], [30, -10], [14, -3],
                   [20, -8], [13, -2], [7, 3], [28, -8], [29, -9], [15, -3], [22, -5], [26, -8], [25, -8],
                   [25, -6], [15, -4], [9, -2], [15, -2], [12, -2], [28, -9], [12, -3], [24, -6], [23, -7],
                   [25, -10], [7, 8], [11, -3], [26, -7], [7, 1], [23, -9], [6, 0], [22, -10], [27, -6],
                   [8, 1], [22, -8], [13, -4], [7, 6], [28, -6], [11, -4], [12, -4], [26, -9], [7, 4],
                   [24, -10], [23, -8], [30, -8], [7, 0], [9, -1], [10, -1], [26, -5], [22, -9], [6, 5],
                   [7, 5], [23, -6], [28, -10], [10, -2], [11, -1], [20, -9], [14, -2], [29, -7], [13, -3],
                   [23, -5], [24, -8], [27, -9], [30, -7], [28, -5], [21, -10], [7, 9], [6, 6], [21, -5],
                   [27, -10], [7, 2], [30, -9], [21, -8], [22, -7], [24, -9], [20, -6], [6, 9], [29, -5],
                   [8, -2], [27, -8], [30, -5], [24, -7]
                 ]
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
          .to eq [[], #  0
                  [], #  1
                  [], #  2
                  [], #  3
                  [], #  4
                  [], #  5: 5 + 4 + 3 + 2 + 1 + 0 ... never reaches 20
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
                  [], # 16
                  [], # 17
                  [], # 18
                  [], # 19
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
