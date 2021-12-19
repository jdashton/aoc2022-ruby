# frozen_string_literal: true

require "aoc2021/puzzles/trick_shot"

RSpec.describe AoC2021::Snailfish do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "#addition" do
    context "with two numbers" do
      subject { AoC2021::Snailfish.new StringIO.new(<<~NUMBERS) }
        [9,1]
      NUMBERS

      it "produces the expected number" do
        expect(subject.addition("[1,2]", "[[3,4],5]")).to eq "[[1,2],[[3,4],5]]"
      end
    end

    context "with 4-num example" do
      subject { AoC2021::Snailfish.new StringIO.new(<<~NUMBERS) }
        [1,1]
        [2,2]
        [3,3]
        [4,4]
      NUMBERS

      it "produces the expected number" do
        expect(subject.number).to eq "[[[[1,1],[2,2]],[3,3]],[4,4]]"
      end
    end

    context "with 5-num example" do
      subject { AoC2021::Snailfish.new StringIO.new(<<~NUMBERS) }
        [1,1]
        [2,2]
        [3,3]
        [4,4]
        [5,5]
      NUMBERS

      it "produces the expected number" do
        expect(subject.number).to eq "[[[[3,0],[5,3]],[4,4]],[5,5]]"
      end
    end

    context "with 6-num example" do
      subject { AoC2021::Snailfish.new StringIO.new(<<~NUMBERS) }
        [1,1]
        [2,2]
        [3,3]
        [4,4]
        [5,5]
        [6,6]
      NUMBERS

      it "produces the expected number" do
        expect(subject.number).to eq "[[[[5,0],[7,4]],[5,5]],[6,6]]"
      end
    end

    context "with the slightly larger example" do
      subject { AoC2021::Snailfish.new StringIO.new(<<~NUMBERS) }
        [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
        [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
        [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
        [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
        [7,[5,[[3,8],[1,4]]]]
        [[2,[2,2]],[8,[8,1]]]
        [2,9]
        [1,[[[9,3],9],[[9,0],[0,7]]]]
        [[[5,[7,4]],7],1]
        [[[[4,2],2],6],[8,7]]
      NUMBERS

      it "produces the expected number" do
        expect(subject.number).to eq "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"
      end
    end
  end

  describe "#reduce" do
    subject { AoC2021::Snailfish.new StringIO.new(<<~NUMBERS) }
      [9,1]
    NUMBERS

    context "when exploding" do
      it "produces the expected number" do
        expect(subject.reduce("[[[[[9,8],1],2],3],4]")).to eq "[[[[0,9],2],3],4]"
        expect(subject.reduce("[7,[6,[5,[4,[3,2]]]]]")).to eq "[7,[6,[5,[7,0]]]]"
        expect(subject.reduce("[[6,[5,[4,[3,2]]]],1]")).to eq "[[6,[5,[7,0]]],3]"
        expect(subject.reduce("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")).to eq "[[3,[2,[8,0]]],[9,[5,[7,0]]]]"
      end
    end

    context "and with splitting" do
      it "produces the expected number" do
        expect(subject.addition("[[[[4,3],4],4],[7,[[8,4],9]]]", "[1,1]")).to eq "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"
        expect(subject.addition("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]", "[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]")).to eq "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]"
        expect(subject.addition("[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]", "[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]")).to eq "[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]"
        expect(subject.addition("[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]", "[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]")).to eq "[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]"
        expect(subject.addition("[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]", "[7,[5,[[3,8],[1,4]]]]")).to eq "[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]"
        expect(subject.addition("[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]", "[[2,[2,2]],[8,[8,1]]]")).to eq "[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]"
        expect(subject.addition("[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]", "[2,9]")).to eq "[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]"
        expect(subject.addition("[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]", "[1,[[[9,3],9],[[9,0],[0,7]]]]")).to eq "[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]"
        expect(subject.addition("[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]", "[[[5,[7,4]],7],1]")).to eq "[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]"
        expect(subject.addition("[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]", "[[[[4,2],2],6],[8,7]]")).to eq "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"
      end
    end
  end

  describe "#magnitude_of_sum" do
    subject { AoC2021::Snailfish.new StringIO.new(<<~NUMBERS) }
      [9,1]
    NUMBERS

    it "finds the expected magnitudes" do
      expect(subject.magnitude_of_sum("[9,1]")).to eq 29
      expect(subject.magnitude_of_sum("[1,9]")).to eq 21
      expect(subject.magnitude_of_sum("[[9,1],[1,9]]")).to eq 129
      expect(subject.magnitude_of_sum("[[1,2],[[3,4],5]]")).to eq 143
      expect(subject.magnitude_of_sum("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]")).to eq 1384
      expect(subject.magnitude_of_sum("[[[[1,1],[2,2]],[3,3]],[4,4]]")).to eq 445
      expect(subject.magnitude_of_sum("[[[[3,0],[5,3]],[4,4]],[5,5]]")).to eq 791
      expect(subject.magnitude_of_sum("[[[[5,0],[7,4]],[5,5]],[6,6]]")).to eq 1137
      expect(subject.magnitude_of_sum("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")).to eq 3488
      expect(subject.magnitude_of_sum("[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]")).to eq 4140
    end
  end
end
