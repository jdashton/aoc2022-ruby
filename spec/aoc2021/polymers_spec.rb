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

    describe "#iterate" do
      it "gets the expected hash after 0 iterations" do
        expect(subject.iterate(0, subject.string_to_pairs("NNCB")))
          .to eq({ "NN" => 1, "NC" => 1, "CB" => 1 })
      end

      it "gets the expected hash after 1 iteration" do
        expect(subject.iterate(1, subject.string_to_pairs("NNCB")))
          .to eq({ "NC" => 1, "CN" => 1, "NB" => 1, "BC" => 1, "CH" => 1, "HB" => 1 })
      end

      it "gets the expected hash after 2 iterations" do
        expect(subject.iterate(2, { "NN" => 1, "NC" => 1, "CB" => 1 }))
          .to eq({ "NB" => 2, "BC" => 2, "CC" => 1, "CN" => 1, "BB" => 2, "CB" => 2, "BH" => 1, "HC" => 1 })
      end

      it "gets the expected hash after 3 iteration" do
        expect(subject.iterate(3, { "NN" => 1, "NC" => 1, "CB" => 1 }))
          .to eq({ "NB" => 4, "BB" => 4, "BC" => 3, "CN" => 2, "NC" => 1, "CC" => 1, "BN" => 2, "CH" => 2,
                   "HB" => 3, "BH" => 1, "HH" => 1 })
      end

      it "gets the expected hash after 4 iterations" do
        expect(subject.iterate(4, { "NN" => 1, "NC" => 1, "CB" => 1 }))
          .to eq({ "NB" => 9, "BB" => 9, "BN" => 6, "BC" => 4, "CC" => 2, "CN" => 3, "NC" => 1, "CB" => 5,
                   "BH" => 3, "HC" => 3, "HH" => 1, "HN" => 1, "NH" => 1 })
      end
    end

    describe "#score" do
      it "scores NNCB" do
        expect(subject.score("N", { "NN" => 1, "NC" => 1, "CB" => 1 }))
          .to eq({ "N" => 2, "C" => 1, "B" => 1 })
      end

      it "scores NCNBCHB" do
        expect(subject.score("N", { "NC" => 1, "CN" => 1, "NB" => 1, "BC" => 1, "CH" => 1, "HB" => 1 }))
          .to eq({ "N" => 2, "C" => 2, "B" => 2, "H" => 1 })
      end

      it "scores NBCCNBBBCBHCB" do
        expect(subject.score("N", { "NB" => 2, "BC" => 2, "CC" => 1, "CN" => 1, "BB" => 2, "CB" => 2, "BH" => 1, "HC" => 1 }))
          .to eq({ "N" => 2, "B" => 6, "C" => 4, "H" => 1 })
      end

      it "scores NBBBCNCCNBBNBNBBCHBHHBCHB" do
        expect(subject.score("N", { "NB" => 4, "BB" => 4, "BC" => 3, "CN" => 2, "NC" => 1, "CC" => 1, "BN" => 2, "CH" => 2,
                                    "HB" => 3, "BH" => 1, "HH" => 1 }))
          .to eq({ "N" => 5, "B" => 11, "C" => 5, "H" => 4 })
      end

      it "scores NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB" do
        expect(subject.score("N", { "NB" => 9, "BB" => 9, "BN" => 6, "BC" => 4, "CC" => 2, "CN" => 3, "NC" => 1, "CB" => 5,
                                    "BH" => 3, "HC" => 3, "HH" => 1, "HN" => 1, "NH" => 1 }))
          .to eq({ "N" => 11, "B" => 23, "C" => 10, "H" => 5 })
      end
    end

    describe "#difference" do
      it "finds a difference of 1588 after 10 steps" do
        expect(subject.process(10)).to eq 1588
      end

      it "finds a difference of 117020 after 16 steps" do
        expect(subject.process(16)).to eq 117_020
      end

      it "finds a difference of 2188189693529 after 40 steps" do
        expect(subject.process(40)).to eq 2_188_189_693_529
      end
    end
  end
end
