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
    context "with my actual input algorithm - starting black" do
      subject { AoC2021::TrenchMap.new StringIO.new(<<~NUMBERS) }
        #.#..##..##....#.####.#...##..###..#.#.##..##....###..#.##.#.#.#......##...#..##...#####.##..##...##..#.##.##..###.##.##...##....###.##.#...#.#.##..#..###.#.##.#.##.####.###.#..#######.##..##..#.##..#####.#..###.####.##....####.#....#...#..#..#....#..#...####.....#.##.###.##.##.###..###.##.###...#.##..#.###.##..##..#.##...##....##.#...#..#...#.##.#..#.###...#.#.##...#..#......#.#...#######.###.##.####.#.#.#.#.#.#.#######....##.##.##..##.##....##....##.##..####..#.#.##...###.##...#..##...#####.#.#.##.#.####.

        .
      NUMBERS

      it "finds the expected number of lit pixels after 0 enhancements" do
        expect(subject.lit_pixels_after(0)).to eq 0
      end

      it "finds the expected images after 0 enhancements" do
        expect(subject.enhance(0)).to eq <<~PIXELS
          .
        PIXELS
      end

      it "finds the expected number of lit pixels after 1 enhancement" do
        expect(subject.lit_pixels_after(1)).to eq 9
      end

      it "finds the expected images after 1 enhancement" do
        expect(subject.enhance(1)).to eq <<~PIXELS
          ###
          ###
          ###
        PIXELS
      end

      it "finds the expected number of lit pixels after 2 enhancements" do
        expect(subject.lit_pixels_after(2)).to eq 0
      end

      it "finds the expected images after 2 enhancements" do
        expect(subject.enhance(2)).to eq <<~PIXELS
          .....
          .....
          .....
          .....
          .....
        PIXELS
      end

      it "finds the expected number of lit pixels after 3 enhancements" do
        expect(subject.lit_pixels_after(3)).to eq 49
      end

      it "finds the expected images after 3 enhancements" do
        expect(subject.enhance(3)).to eq <<~PIXELS
          #######
          #######
          #######
          #######
          #######
          #######
          #######
        PIXELS
      end

      it "finds the expected number of lit pixels after 4 enhancements" do
        expect(subject.lit_pixels_after(4)).to eq 0
      end

      it "finds the expected images after 4 enhancements" do
        expect(subject.enhance(4)).to eq <<~PIXELS
          .........
          .........
          .........
          .........
          .........
          .........
          .........
          .........
          .........
        PIXELS
      end

      it "finds the expected number of lit pixels after 5 enhancements" do
        expect(subject.lit_pixels_after(5)).to eq 121
      end

      it "finds the expected images after 5 enhancements" do
        expect(subject.enhance(5)).to eq <<~PIXELS
          ###########
          ###########
          ###########
          ###########
          ###########
          ###########
          ###########
          ###########
          ###########
          ###########
          ###########
        PIXELS
      end

      it "finds the expected number of lit pixels after 6 enhancements" do
        expect(subject.lit_pixels_after(6)).to eq 0
      end

      it "finds the expected images after 6 enhancements" do
        expect(subject.enhance(6)).to eq <<~PIXELS
          .............
          .............
          .............
          .............
          .............
          .............
          .............
          .............
          .............
          .............
          .............
          .............
          .............
        PIXELS
      end
    end

    context "with my actual input algorithm - starting white" do
      subject { AoC2021::TrenchMap.new StringIO.new(<<~NUMBERS) }
        #.#..##..##....#.####.#...##..###..#.#.##..##....###..#.##.#.#.#......##...#..##...#####.##..##...##..#.##.##..###.##.##...##....###.##.#...#.#.##..#..###.#.##.#.##.####.###.#..#######.##..##..#.##..#####.#..###.####.##....####.#....#...#..#..#....#..#...####.....#.##.###.##.##.###..###.##.###...#.##..#.###.##..##..#.##...##....##.#...#..#...#.##.#..#.###...#.#.##...#..#......#.#...#######.###.##.####.#.#.#.#.#.#.#######....##.##.##..##.##....##....##.##..####..#.#.##...###.##...#..##...#####.#.#.##.#.####.

        #
      NUMBERS

      it "finds the expected number of lit pixels after 0 enhancements" do
        expect(subject.lit_pixels_after(0)).to eq 1
      end

      it "finds the expected images after 0 enhancements" do
        expect(subject.enhance(0)).to eq <<~PIXELS
          #
        PIXELS
      end

      it "finds the expected number of lit pixels after 1 enhancement" do
        expect(subject.lit_pixels_after(1)).to eq 3
      end

      it "finds the expected images after 1 enhancement" do
        expect(subject.enhance(1)).to eq <<~PIXELS
          .#.
          ..#
          ..#
        PIXELS
      end

      it "finds the expected number of lit pixels after 2 enhancements" do
        expect(subject.lit_pixels_after(2)).to eq 17
      end

      it "finds the expected images after 2 enhancements" do
        expect(subject.enhance(2)).to eq <<~PIXELS
          ##.##
          ##..#
          ##.##
          #.##.
          ##.#.
        PIXELS
      end

      it "finds the expected number of lit pixels after 3 enhancements" do
        expect(subject.lit_pixels_after(3)).to eq 26
      end

      it "finds the expected images after 3 enhancements" do
        expect(subject.enhance(3)).to eq <<~PIXELS
          ..##.#.
          ####.#.
          ..#.#.#
          .#.####
          ...#.##
          .#..###
          ...#.##
        PIXELS
      end
    end

    # trench_map = File.open("input/day20a.txt") { |file| TrenchMap.new file }
    context "with actual input" do
      subject { File.open("input/day20a.txt") { AoC2021::TrenchMap.new _1 } }

      it "finds the expected number of lit pixels after 2 enhancements" do
        expect(subject.lit_pixels_after(2)).to eq 5622
      end

      it "finds the expected number of lit pixels after 50 enhancements" do
        expect(subject.lit_pixels_after(50)).to eq 20395
      end
    end

    context "with first example" do
      subject { AoC2021::TrenchMap.new StringIO.new(<<~NUMBERS) }
        ..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

        #..#.
        #....
        ##..#
        ..#..
        ..###
      NUMBERS

      it "finds the expected number of lit pixels after 0 enhancements" do
        expect(subject.lit_pixels_after(0)).to eq 10
      end

      it "finds the expected number of lit pixels after 1 enhancement" do
        expect(subject.lit_pixels_after(1)).to eq 24
      end

      it "finds the expected number of lit pixels after 2 enhancements" do
        expect(subject.lit_pixels_after(2)).to eq 35
      end

      it "finds the expected number of lit pixels after 50 enhancements" do
        expect(subject.lit_pixels_after(50)).to eq 3351
      end

      it "finds the expected images after 0 enhancements" do
        expect(subject.enhance(0)).to eq <<~PIXELS
          #..#.
          #....
          ##..#
          ..#..
          ..###
        PIXELS
      end

      it "finds the expected images after 1 enhancement" do
        expect(subject.enhance(1)).to eq <<~PIXELS
          .##.##.
          #..#.#.
          ##.#..#
          ####..#
          .#..##.
          ..##..#
          ...#.#.
        PIXELS
      end

      it "finds the expected images after 2 enhancements" do
        expect(subject.enhance(2)).to eq <<~PIXELS
          .......#.
          .#..#.#..
          #.#...###
          #...##.#.
          #.....#.#
          .#.#####.
          ..#.#####
          ...##.##.
          ....###..
        PIXELS
      end

      # Don't guess these again: 5539, 5549 (too low), correct was 5622
      # Part 2: 21271 (too high), correct was 20395. I had been continuing for 50
      # iterations after having already performend 2 iterations, so overshot.
    end
  end
end
