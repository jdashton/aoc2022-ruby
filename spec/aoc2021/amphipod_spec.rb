# frozen_string_literal: true

require "aoc2021/puzzles/amphipod"

RSpec.describe AoC2021::Amphipod do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "#final_state" do
    it "detects a final state" do
      expect(AoC2021::Amphipod.final_state?([:empty, :empty,
                                             %i[A A A A], :empty,
                                             %i[B B B B], :empty,
                                             %i[C C C C], :empty,
                                             %i[D D D D], :empty, :empty])).to be_truthy
    end
  end
end
