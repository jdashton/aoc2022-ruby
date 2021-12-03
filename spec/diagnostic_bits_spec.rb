# frozen_string_literal: true

require "aoc2021/diagnostic_bits"

RSpec.describe AoC2021::DiagnosticBits do
  describe "#power_consumption" do
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
end
