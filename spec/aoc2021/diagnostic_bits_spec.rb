# frozen_string_literal: true

require "aoc2021/puzzles/diagnostic_bits"

RSpec.describe AoC2021::DiagnosticBits do
  describe "#power_consumption" do
    context "with one number" do
      subject { AoC2021::DiagnosticBits.new StringIO.new(<<~BITS) }
        00100
      BITS

      it "reaches 108" do
        expect(subject.power_consumption).to eq 108
      end
    end

    context "with three numbers" do
      subject { AoC2021::DiagnosticBits.new StringIO.new(<<~BITS) }
        00100
        11110
        10110
      BITS

      it "reaches 198" do
        expect(subject.power_consumption).to eq 198
      end
    end

    context "with provided test data" do
      subject { AoC2021::DiagnosticBits.new StringIO.new(<<~BITS) }
        00100
        11110
        10110
        10111
        10101
        01111
        00111
        11100
        10000
        11001
        00010
        01010
      BITS

      it "reaches 198" do
        expect(subject.power_consumption).to eq 198
      end
    end
  end

  describe "#life_support_rating" do
    context "with three numbers" do
      subject { AoC2021::DiagnosticBits.new StringIO.new(<<~BITS) }
        00100
        11110
        10110
      BITS

      it "reaches 120" do
        expect(subject.life_support_rating).to eq 120
      end
    end

    context "with provided test data" do
      subject { AoC2021::DiagnosticBits.new StringIO.new(<<~BITS) }
        00100
        11110
        10110
        10111
        10101
        01111
        00111
        11100
        10000
        11001
        00010
        01010
      BITS

      it "reaches 230" do
        expect(subject.life_support_rating).to eq 230
      end
    end
  end
end
