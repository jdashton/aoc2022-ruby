# frozen_string_literal: true

require "aoc2021/vents"

RSpec.describe AoC2021::Vents do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "#overlaps" do
    context "with provided input" do
      subject { AoC2021::Vents.new StringIO.new(<<~BITS) }
        0,9 -> 5,9
        8,0 -> 0,8
        9,4 -> 3,4
        2,2 -> 2,1
        7,0 -> 7,4
        6,4 -> 2,0
        0,9 -> 2,9
        3,4 -> 1,4
        0,0 -> 8,8
        5,5 -> 8,2
      BITS

      it "scores 5" do
        expect(subject.overlaps).to eq 5
      end

      it "scores 12 with diagonals" do
        expect(subject.overlaps_with_diagonals).to eq 12
      end
    end
  end
end
