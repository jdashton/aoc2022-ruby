# frozen_string_literal: true

require "rspec"

require "aoc2021/puzzles/polymers"

RSpec.describe AoC2021::Polymers do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context "with provided input" do
    subject { AoC2021::Polymers.new StringIO.new(<<~BITS) }
      NNCB

      CH -> B
      HH -> N
      CB -> H
      NH -> C
      HB -> C
      HC -> B
      HN -> C
      NN -> C
      BH -> H
      NC -> B
      NB -> B
      BN -> B
      BB -> N
      BC -> B
      CC -> N
      CN -> C
    BITS

    describe "#insert" do
      it "gets the expected chain after 1 insertion" do
        expect(subject.insert(1)).to eq "NCNBCHB"
      end
    end

    describe "#insert" do
      it "gets the expected chain after 2 insertion" do
        expect(subject.insert(2)).to eq "NBCCNBBBCBHCB"
      end
    end

    describe "#insert" do
      it "gets the expected chain after 3 insertion" do
        expect(subject.insert(3)).to eq "NBBBCNCCNBBNBNBBCHBHHBCHB"
      end
    end

    describe "#insert" do
      it "gets the expected chain after 4 insertion" do
        expect(subject.insert(4)).to eq "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB"
      end
    end

    describe "#difference" do
      it "finds a difference of 1588 after 10 steps" do
        expect(AoC2021::Polymers.difference(subject.insert(10))).to eq 1588
      end

      it "finds a difference of 117020 after 16 steps" do
        expect(AoC2021::Polymers.difference(subject.insert(16))).to eq 117_020
      end
      #
      # it "finds a difference of 2188189693529 after 40 steps" do
      #   expect(AoC2021::Polymers.difference(subject.insert(40))).to eq 2_188_189_693_529
      # end
    end
  end
end
