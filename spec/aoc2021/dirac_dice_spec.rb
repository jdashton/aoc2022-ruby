# frozen_string_literal: true

require "aoc2021/puzzles/trench_map"

RSpec.describe AoC2021::DiracDice do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "#first300" do
    subject { AoC2021::DiracDice.new StringIO.new(<<~NUMBERS) }
      Player 1 starting position: 4
      Player 2 starting position: 8
    NUMBERS

    it "runs" do
      expect(subject.first300).to eq nil
    end
  end
end
