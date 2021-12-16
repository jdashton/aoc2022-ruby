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
      D2FE28
    BITS

    describe "#sum_version_numbers" do
      it "converts hexadecimal to binary" do
        expect(subject.make_packet("D2FE28")).to eq AoC2021::PacketDecoder::Packet.new("110100101111111000101000")
      end

      it "reads and removes a number from a stream of bits" do
        expect(subject.make_packet("D2FE28").read_packet)
          .to eq [{ ver: 6, type: :number, val: 2021 }, "000"]
      end

      it "parses operator packets" do
        expect(subject.make_packet("38006F45291200").read_packet)
          .to eq [{ ver: 1, type: :less_than, val: [
            { ver: 6, type: :number, val: 10 },
            { ver: 2, type: :number, val: 20 }
          ] }, "0000000"]
        expect(subject.make_packet("EE00D40C823060").read_packet)
          .to eq [{ ver: 7, type: :maximum, val: [
            { ver: 2, type: :number, val: 1 },
            { ver: 4, type: :number, val: 2 },
            { ver: 1, type: :number, val: 3 }
          ] }, "00000"]
      end

      it "finds of sum of 16 for '8A004A801A8002F478'" do
        expect(subject.sum_version_numbers(subject.make_packet("8A004A801A8002F478").read_packet[0])).to eq 16
      end

      it "finds of sum of 12 for '620080001611562C8802118E34'" do
        expect(subject.sum_version_numbers(subject.make_packet("620080001611562C8802118E34").read_packet[0])).to eq 12
      end

      it "finds of sum of 23 for 'C0015000016115A2E0802F182340'" do
        expect(subject.sum_version_numbers(subject.make_packet("C0015000016115A2E0802F182340").read_packet[0])).to eq 23
      end

      it "finds of sum of 31 for 'A0016C880162017C3686B18A3D4780'" do
        expect(subject.sum_version_numbers(subject.make_packet("A0016C880162017C3686B18A3D4780").read_packet[0])).to eq 31
      end
    end
  end

  describe "#execute" do
    context "with C200B40A82" do
      subject { AoC2021::PacketDecoder.new StringIO.new(<<~BITS) }
        C200B40A82
      BITS

      it "results in 3 (sum)" do
        expect(subject.execute).to eq 3
      end
    end

    context "with 04005AC33890" do
      subject { AoC2021::PacketDecoder.new StringIO.new(<<~BITS) }
        04005AC33890
      BITS

      it "results in 54 (product)" do
        expect(subject.execute).to eq 54
      end
    end

    context "with 880086C3E88112" do
      subject { AoC2021::PacketDecoder.new StringIO.new(<<~BITS) }
        880086C3E88112
      BITS

      it "results in 7 (minimum)" do
        expect(subject.execute).to eq 7
      end
    end

    context "with CE00C43D881120" do
      subject { AoC2021::PacketDecoder.new StringIO.new(<<~BITS) }
        CE00C43D881120
      BITS

      it "results in 9 (maximum)" do
        expect(subject.execute).to eq 9
      end
    end

    context "with D8005AC2A8F0" do
      subject { AoC2021::PacketDecoder.new StringIO.new(<<~BITS) }
        D8005AC2A8F0
      BITS

      it "results in 1 (less than)" do
        expect(subject.execute).to eq 1
      end
    end

    context "with F600BC2D8F" do
      subject { AoC2021::PacketDecoder.new StringIO.new(<<~BITS) }
        F600BC2D8F
      BITS

      it "results in 0 (greater than)" do
        expect(subject.execute).to eq 0
      end
    end

    context "with 9C005AC2F8F0" do
      subject { AoC2021::PacketDecoder.new StringIO.new(<<~BITS) }
        9C005AC2F8F0
      BITS

      it "results in 0 (equal to)" do
        expect(subject.execute).to eq 0
      end
    end

    context "with 9C0141080250320F1802104A08" do
      subject { AoC2021::PacketDecoder.new StringIO.new(<<~BITS) }
        9C0141080250320F1802104A08
      BITS

      it "results in 1 (equal to)" do
        expect(subject.execute).to eq 1
      end
    end
  end
end
