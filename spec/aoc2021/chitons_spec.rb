# frozen_string_literal: true

require "rspec"

require "aoc2021/puzzles/cave_paths"

RSpec.describe AoC2021::Chitons do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context "with provided input" do
    subject { AoC2021::Chitons.new StringIO.new(<<~BITS) }
      1163751742
      1381373672
      2136511328
      3694931569
      7463417111
      1319128137
      1359912421
      3125421639
      1293138521
      2311944581
    BITS

    describe "#lowest_risk" do
      it "finds a path with risk 40" do
        expect(subject.lowest_risk).to eq 40
      end
    end
  end
end
