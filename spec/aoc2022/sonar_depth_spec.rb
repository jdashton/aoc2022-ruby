# frozen_string_literal: true

require "aoc2022/puzzles/sonar_depth"

RSpec.describe AoC2022::SonarDepth do
  describe "#count_increases" do
    context "with [1, 3, 2]" do
      subject { described_class.new StringIO.new(<<~NUMBERS) }
        1
        3
        2
      NUMBERS

      it "counts 1 increase" do
        expect(subject.count_increases).to eq 1
      end
    end

    context "with [1, 3, 2, 4]" do
      subject { described_class.new StringIO.new(<<~NUMBERS) }
        1
        3
        2
        4
      NUMBERS

      it "counts 2 increases" do
        expect(subject.count_increases).to eq 2
      end
    end

    context "with provided test data" do
      subject { described_class.new StringIO.new(<<~NUMBERS) }
        199
        200
        208
        210
        200
        207
        240
        269
        260
        263
      NUMBERS

      it "counts 7 increases" do
        expect(subject.count_increases).to eq 7
      end
    end
  end

  describe "#count_triplet_increases" do
    context "with [1, 3, 2, 4, 3, 5]" do
      subject { described_class.new StringIO.new(<<~NUMBERS) }
        1
        3
        2
        4
        3
        5
      NUMBERS

      it "counts 2 increases" do
        expect(subject.count_triplet_increases).to eq 2
      end
    end

    context "with [1, 3, 2, 4, 3, 0]" do
      subject { described_class.new StringIO.new(<<~NUMBERS) }
        1
        3
        2
        4
        3
        0
      NUMBERS

      it "counts 1 increase" do
        expect(subject.count_triplet_increases).to eq 1
      end
    end

    context "with [1, 3, 2, 4, 3, 5, 4]" do
      subject { described_class.new StringIO.new(<<~NUMBERS) }
        1
        3
        2
        4
        3
        5
        4
      NUMBERS

      it "counts 2 increases" do
        expect(subject.count_triplet_increases).to eq 2
      end
    end

    context "with provided test data" do
      subject { described_class.new StringIO.new(<<~NUMBERS) }
        199
        200
        208
        210
        200
        207
        240
        269
        260
        263
      NUMBERS

      it "counts 5 increases" do
        expect(subject.count_triplet_increases).to eq 5
      end
    end
  end
end
