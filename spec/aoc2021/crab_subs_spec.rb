# frozen_string_literal: true

require "rspec"

require "aoc2021/crab_subs"

RSpec.describe AoC2021::CrabSubs do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "#minimal_move" do
    context "with provided input" do
      subject { AoC2021::CrabSubs.new StringIO.new(<<~BITS) }
        16,1,2,0,4,2,7,1,2,14
      BITS

      it "finds a minimal cost of 37 fuel" do
        expect(subject.minimal_move).to eq 37
      end

      it "finds a minimal cost of 168 fuel with revised understanding" do
        expect(subject.minimal_move_revised).to eq 168
      end
    end
  end
end
