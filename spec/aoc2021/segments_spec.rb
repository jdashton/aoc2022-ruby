# frozen_string_literal: true

require "rspec"

require "aoc2021/segments"

RSpec.describe DigitLine do
  subject do
    DigitLine.new(*["bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd", "ed bcgafe cdgba cbgef"].map(&:split))
  end

  it "assigns 2 for the set bdacg" do
    expect(subject.dictionary[Set.new("bdacg".chars)]).to eq 2
  end
end

RSpec.describe AoC2021::Segments do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "#easy_digits" do
    context "with short sample" do
      subject { AoC2021::Segments.new StringIO.new(<<~BITS) }
        acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
      BITS

      it "finds an output value of 5353" do
        expect(subject.sum_of_all_outputs).to eq 5353
      end
    end

    context "with provided input" do
      subject { AoC2021::Segments.new StringIO.new(<<~BITS) }
        be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
        edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
        fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
        fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
        aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
        fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
        dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
        bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
        egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
        gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
      BITS

      it "identifies 26 instances of digits that use a unique number of segments" do
        expect(subject.easy_digits).to eq 26
      end

      it "sums the output values to get 61229" do
        expect(subject.sum_of_all_outputs).to eq 61_229
      end
    end
  end
end
