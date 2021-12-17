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
  end
end
