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
      expect(subject.deterministic_die).to be_a(String)
    end
  end

  describe "#dirac_to_score" do
    subject { AoC2021::DiracDice.new StringIO.new(<<~NUMBERS) }
      Player 1 starting position: 4
      Player 2 starting position: 8
    NUMBERS

    it "gets the expected results for wins at 1 point" do
      expect(subject.dirac_to_score(1)).to eq [27, 0]
    end

    it "gets the expected results for wins at 2 points" do
      expect(subject.dirac_to_score(2)).to eq [183, 156]
    end

    it "gets the expected results for wins at 3 points" do
      expect(subject.dirac_to_score(3)).to eq [990, 207]
    end

    it "gets the expected results for wins at 4 points" do
      expect(subject.dirac_to_score(4)).to eq [2930, 971]
    end

    it "gets the expected results for wins at 5 points" do
      expect(subject.dirac_to_score(5)).to eq [7907, 2728]
    end

    it "gets the expected results for wins at 6 points" do
      expect(subject.dirac_to_score(6)).to eq [30_498, 7203]
    end

    it "gets the expected results for wins at 7 points" do
      expect(subject.dirac_to_score(7)).to eq [127_019, 152_976]
    end

    it "gets the expected results for wins at 8 points" do
      expect(subject.dirac_to_score(8)).to eq [655_661, 1_048_978]
    end

    it "gets the expected results for wins at 9 points" do
      expect(subject.dirac_to_score(9)).to eq [4_008_007, 4_049_420]
    end

    it "gets the expected results for wins at 10 points" do
      expect(subject.dirac_to_score(10)).to eq [18_973_591, 12_657_100]
    end
  end
end
