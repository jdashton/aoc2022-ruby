# frozen_string_literal: true

require "rspec"

require "aoc2021/smoke_points"

RSpec.describe AoC2021::SmokePoints do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "#basins" do
    context "with tiny input" do
      subject { AoC2021::SmokePoints.new StringIO.new(<<~BITS) }
        219
        399
      BITS

      it "finds one pool of size 3" do
        expect(subject.basins).to eq [3]
      end
    end

    context "with small input" do
      subject { AoC2021::SmokePoints.new StringIO.new(<<~BITS) }
        2199943210
        3999994921
      BITS

      it "finds one pool of size 3" do
        expect(subject.basins).to eq [3, 8]
      end
    end
  end

  describe "#easy_digits" do
    context "with provided input" do
      subject { AoC2021::SmokePoints.new StringIO.new(<<~BITS) }
        2199943210
        3987894921
        9856789892
        8767896789
        9899965678
      BITS

      it "identifies a risk level of 15 for the low points" do
        expect(subject.risk_levels).to eq 15
      end

      it "finds the three largest basins to produce 1134" do
        expect(subject.multiply_basins).to eq 1134
      end
    end
  end
end
