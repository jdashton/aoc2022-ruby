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

    it 'finds this final state' do
      expect(unstable_diffusion.spread_out.render).to eq <<~DATA
        ......#.....
        ..........#.
        .#.#..#.....
        .....#......
        ..#.....#..#
        #......##...
        ....##......
        .#........#.
        ...#.#..#...
        ............
        ...#..#..#..
      DATA
    end

    it 'finds 110 as the number of empty ground tiles after 10 rounds' do
      expect(unstable_diffusion.part_one).to eq 110
    end

    it 'finds 20 as the first round with no moves' do
      expect(unstable_diffusion.part_two).to eq 20
    end
  end

  context 'with small test data' do
    subject(:unstable_diffusion) { described_class.new StringIO.new(<<~DATA) }
      .....
      ..##.
      ..#..
      .....
      ..##.
      .....
    DATA

    it 'renders the input as expected' do
      expect(unstable_diffusion.render).to eq <<~DATA
        ##
        #.
        ..
        ##
      DATA
    end

    it 'finds this final state' do
      expect(unstable_diffusion.spread_out.render).to eq <<~DATA
        ..#..
        ....#
        #....
        ....#
        .....
        ..#..
      DATA
    end

    it 'finds 25 as the number of spaces in the final state' do
      expect(unstable_diffusion.spread_out.count_spaces).to eq 25
    end
  end

  context 'with actual input data' do
    subject(:unstable_diffusion) { File.open('input/day23.txt') { |file| described_class.new file } }

    it 'finds 4116 as the number of empty ground tiles after 10 rounds' do
      expect(unstable_diffusion.part_one).to eq 4116
    end

    xit 'finds 984 as the first round with no moves' do
      expect(unstable_diffusion.part_two).to eq 984
    end
  end
end
