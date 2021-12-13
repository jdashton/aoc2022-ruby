# frozen_string_literal: true

require "rspec"

require "aoc2021/puzzles/cave_paths"

RSpec.describe AoC2021::CavePaths do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context "with small input" do
    subject { AoC2021::CavePaths.new StringIO.new(<<~BITS) }
      start-A
      start-b
      A-c
      A-b
      b-d
      A-end
      b-end
    BITS

    describe "#successes" do
      it "finds 10 paths" do
        expect(subject.size).to eq 10
        # expect(subject.successes.size).to eq 10
      end

      it "finds the 10 expected paths" do
        expect(subject.successes).to eq <<~BITS
          start,A,b,A,c,A,end
          start,A,b,A,end
          start,A,b,end
          start,A,c,A,b,A,end
          start,A,c,A,b,end
          start,A,c,A,end
          start,A,end
          start,b,A,c,A,end
          start,b,A,end
          start,b,end
        BITS
      end
    end

    describe "#double_visit" do
      it "finds 36 paths" do
        expect(subject.double_visit_size).to eq 36
      end

      it "finds the 36 expected paths" do
        expect(subject.double_visit).to eq <<~BITS
          start,A,b,A,b,A,c,A,end
          start,A,b,A,b,A,end
          start,A,b,A,b,end
          start,A,b,A,c,A,b,A,end
          start,A,b,A,c,A,b,end
          start,A,b,A,c,A,c,A,end
          start,A,b,A,c,A,end
          start,A,b,A,end
          start,A,b,d,b,A,c,A,end
          start,A,b,d,b,A,end
          start,A,b,d,b,end
          start,A,b,end
          start,A,c,A,b,A,b,A,end
          start,A,c,A,b,A,b,end
          start,A,c,A,b,A,c,A,end
          start,A,c,A,b,A,end
          start,A,c,A,b,d,b,A,end
          start,A,c,A,b,d,b,end
          start,A,c,A,b,end
          start,A,c,A,c,A,b,A,end
          start,A,c,A,c,A,b,end
          start,A,c,A,c,A,end
          start,A,c,A,end
          start,A,end
          start,b,A,b,A,c,A,end
          start,b,A,b,A,end
          start,b,A,b,end
          start,b,A,c,A,b,A,end
          start,b,A,c,A,b,end
          start,b,A,c,A,c,A,end
          start,b,A,c,A,end
          start,b,A,end
          start,b,d,b,A,c,A,end
          start,b,d,b,A,end
          start,b,d,b,end
          start,b,end
        BITS
      end
    end
  end

  context "with medium input" do
    subject { AoC2021::CavePaths.new StringIO.new(<<~BITS) }
      dc-end
      HN-start
      start-kj
      dc-start
      dc-HN
      LN-dc
      HN-end
      kj-sa
      kj-HN
      kj-dc
    BITS

    describe "#successes" do
      it "finds 19 paths" do
        expect(subject.size).to eq 19
      end

      it "finds the 19 expected paths" do
        expect(subject.successes).to eq <<~BITS
          start,HN,dc,HN,end
          start,HN,dc,HN,kj,HN,end
          start,HN,dc,end
          start,HN,dc,kj,HN,end
          start,HN,end
          start,HN,kj,HN,dc,HN,end
          start,HN,kj,HN,dc,end
          start,HN,kj,HN,end
          start,HN,kj,dc,HN,end
          start,HN,kj,dc,end
          start,dc,HN,end
          start,dc,HN,kj,HN,end
          start,dc,end
          start,dc,kj,HN,end
          start,kj,HN,dc,HN,end
          start,kj,HN,dc,end
          start,kj,HN,end
          start,kj,dc,HN,end
          start,kj,dc,end
        BITS
      end
    end
    describe "#double_visit_size" do
      it "finds 103 paths" do
        expect(subject.double_visit_size).to eq 103
      end
    end
  end

  context "with large example input" do
    subject { AoC2021::CavePaths.new StringIO.new(<<~BITS) }
      fs-end
      he-DX
      fs-he
      start-DX
      pj-DX
      end-zg
      zg-sl
      zg-pj
      pj-he
      RW-he
      fs-DX
      pj-RW
      zg-RW
      start-pj
      he-WI
      zg-he
      pj-fs
      start-RW
    BITS

    describe "#successes" do
      it "finds 226 paths" do
        expect(subject.size).to eq 226
      end
    end

    describe "#double_visit_size" do
      it "finds 3509 paths" do
        expect(subject.double_visit_size).to eq 3509
      end
    end
  end
end
