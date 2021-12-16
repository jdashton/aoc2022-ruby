# frozen_string_literal: true

require "rspec"

require "aoc2021/puzzles/packet_decoder"

RSpec.describe AoC2021::PacketDecoder do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context "with provided input" do
    subject { AoC2021::PacketDecoder.new StringIO.new(<<~BITS) }
      1163751742
      1381373672
      2136511328
      3694931569
      7463417111
      1319128137
      1359912421
      3125421639
      1293138521
      2311944581
    BITS

    describe "#sum_version_numbers" do
      it "converts hexadecimal to binary" do
        expect(subject.hex_to_binary("D2FE28")).to eq "110100101111111000101000"
      end

      it "reads and removes a number from a stream of bits" do
        expect(subject.hex_to_binary("D2FE28").read_packet).to eq [:number, 2021]
      end
    end
  end
end
