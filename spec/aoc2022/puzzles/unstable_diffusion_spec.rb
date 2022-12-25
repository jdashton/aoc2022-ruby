# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::UnstableDiffusion do
  context 'with provided test data' do
    subject(:unstable_diffusion) { described_class.new StringIO.new(<<~DATA) }
      ....#..
      ..###.#
      #...#.#
      .#...##
      #.###..
      ##.#.##
      .#..#..
    DATA

    # .....
    # ..##.
    # ..#..
    # .....
    # ..##.
    # .....

    it 'finds 110 as the number of empty ground tiles' do
      expect(unstable_diffusion.part_one).to eq 110
    end
  end

  context 'with small test data' do
    subject(:unstable_diffusion) { described_class.new StringIO.new(<<~DATA) }
      ..#..
      ....#
      #....
      ....#
      .....
      ..#..
    DATA

    it 'finds 110 as the number of empty ground tiles' do
      expect(unstable_diffusion.propose_moves(board, directions)).to eq 110
    end
  end

  context 'with actual input data' do
    subject(:unstable_diffusion) { File.open('input/day23.txt') { |file| described_class.new file } }

    it 'finds 110 as the number of empty ground tiles' do
      expect(unstable_diffusion.part_one).to eq 110
    end
  end
end
