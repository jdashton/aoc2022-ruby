# frozen_string_literal: true

require "aoc2021/puzzles/trench_map"

RSpec.describe AoC2021::TrenchMap do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "#lit_pixels_after" do
    context "with first example" do
      subject { AoC2021::TrenchMap.new StringIO.new(<<~NUMBERS) }
        ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

        #..#.
        #....
        ##..#
        ..#..
        ..###
      NUMBERS

      it "finds the expected number of lit pixels" do
        expect(subject.lit_pixels_after(0)).to eq 10
        expect(subject.lit_pixels_after(1)).to eq 24
        expect(subject.lit_pixels_after(2)).to eq 35
      end

      it "finds the expected images after each enhancement" do
        expect(subject.enhance(0)).to eq <<~PIXELS
          #..#.
          #....
          ##..#
          ..#..
          ..###
        PIXELS
        #   expect(subject.enhance(1)).to eq <<~PIXELS
        #     .##.##.
        #     #..#.#.
        #     ##.#..#
        #     ####..#
        #     .#..##.
        #     ..##..#
        #     ...#.#.
        #   PIXELS
        #   expect(subject.enhance(2)).to eq <<~PIXELS
        #     .......#.
        #     .#..#.#..
        #     #.#...###
        #     #...##.#.
        #     #.....#.#
        #     .#.#####.
        #     ..#.#####
        #     ...##.##.
        #     ....###..
        #   PIXELS
      end
    end
  end
end
