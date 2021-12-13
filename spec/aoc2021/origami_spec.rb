# frozen_string_literal: true

require "rspec"

require "aoc2021/puzzles/origami"

RSpec.describe AoC2021::Origami do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context "with provided input" do
    subject { AoC2021::Origami.new StringIO.new(<<~BITS) }
      6,10
      0,14
      9,10
      0,3
      10,4
      4,11
      6,0
      6,12
      4,1
      0,13
      10,12
      3,4
      3,0
      8,4
      1,10
      2,14
      8,10
      9,0

      fold along y=7
      fold along x=5
    BITS

    describe "#first_fold" do
      it "finds 19 paths" do
        expect(subject).to be_an AoC2021::Origami
      end
    end

    describe "#visible_dots" do
      it "finds 17 dots after the firrst fold" do
        expect(subject.first_fold.visible_dots).to eq 17
      end
    end

    describe "#final_shape" do
      it "displays a square" do
        expect(subject.final_shape).to eq <<~BITS
          #####
          #   #
          #   #
          #   #
          #####
        BITS
      end
    end
  end
end
