# frozen_string_literal: true

require "aoc2021/puzzles/lanternfish"

RSpec.describe AoC2021::Lanternfish do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "#compounded" do
    context "with provided input" do
      subject { AoC2021::Lanternfish.new StringIO.new(<<~BITS) }
        3,4,3,1,2
      BITS

      it "counts 5934 fish" do
        expect(subject.compounded).to eq 5934
      end

      it "counts 26,984,457,539 fish" do
        subject.compounded
        expect(subject.compounded(256 - 80)).to eq 26_984_457_539
      end
    end
  end
end
