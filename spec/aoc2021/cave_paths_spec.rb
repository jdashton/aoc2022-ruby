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
        expect(subject.count).to eq 10
        expect(subject.successes.count).to eq 10
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

    # dc-end
    # HN-start
    # start-kj
    # dc-start
    # dc-HN
    # LN-dc
    # HN-end
    # kj-sa
    # kj-HN
    # kj-dc

    # 19 paths
    # start,HN,dc,HN,end
    # start,HN,dc,HN,kj,HN,end
    # start,HN,dc,end
    # start,HN,dc,kj,HN,end
    # start,HN,end
    # start,HN,kj,HN,dc,HN,end
    # start,HN,kj,HN,dc,end
    # start,HN,kj,HN,end
    # start,HN,kj,dc,HN,end
    # start,HN,kj,dc,end
    # start,dc,HN,end
    # start,dc,HN,kj,HN,end
    # start,dc,end
    # start,dc,kj,HN,end
    # start,kj,HN,dc,HN,end
    # start,kj,HN,dc,end
    # start,kj,HN,end
    # start,kj,dc,HN,end
    # start,kj,dc,end

    # fs-end
    # he-DX
    # fs-he
    # start-DX
    # pj-DX
    # end-zg
    # zg-sl
    # zg-pj
    # pj-he
    # RW-he
    # fs-DX
    # pj-RW
    # zg-RW
    # start-pj
    # he-WI
    # zg-he
    # pj-fs
    # start-RW
    #
    # 226 paths

    context "with provided input" do
      subject { AoC2021::CavePaths.new StringIO.new(<<~BITS) }
        5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526
      BITS
    end
  end
end
