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

    describe "#single_visit_size" do
      it "finds 10 paths" do
        expect(subject.single_visit_size).to eq 10
      end
    end

    describe "#double_visit_size" do
      it "finds 36 paths" do
        expect(subject.double_visit_size).to eq 36
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

    describe "#single_visit_size" do
      it "finds 19 paths" do
        expect(subject.single_visit_size).to eq 19
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

    describe "#single_visit_size" do
      it "finds 226 paths" do
        expect(subject.single_visit_size).to eq 226
      end
    end

    describe "#double_visit_size" do
      it "finds 3509 paths" do
        expect(subject.double_visit_size).to eq 3509
      end
    end
  end
end
