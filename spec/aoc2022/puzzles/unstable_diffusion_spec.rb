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

    it 'finds this state before round 1' do
      expect(unstable_diffusion.render).to eq <<~DATA
        ....#..
        ..###.#
        #...#.#
        .#...##
        #.###..
        ##.#.##
        .#..#..
      DATA
    end

    it 'finds this state after round 1' do
      expect(unstable_diffusion.spread_out(1).render).to eq <<~DATA
        .....#...
        ...#...#.
        .#..#.#..
        .....#..#
        ..#.#.##.
        #..#.#...
        #.#.#.##.
        .........
        ..#..#...
      DATA
    end

    it 'finds this state after round 2' do
      expect(unstable_diffusion.spread_out(2).render).to eq <<~DATA
        ......#....
        ...#.....#.
        ..#..#.#...
        ......#...#
        ..#..#.#...
        #...#.#.#..
        ...........
        .#.#.#.##..
        ...#..#....
      DATA
    end

    it 'finds this state after round 3' do
      expect(unstable_diffusion.spread_out(3).render).to eq <<~DATA
        ......#....
        ....#....#.
        .#..#...#..
        ......#...#
        ..#..#.#...
        #..#.....#.
        ......##...
        .##.#....#.
        ..#........
        ......#....
      DATA
    end

    it 'finds this state after round 4' do
      expect(unstable_diffusion.spread_out(4).render).to eq <<~DATA
        ......#....
        .....#....#
        .#...##....
        ..#.....#.#
        ........#..
        #...###..#.
        .#......#..
        ...##....#.
        ...#.......
        ......#....
      DATA
    end

    it 'finds this state after round 5' do
      expect(unstable_diffusion.spread_out(5).render).to eq <<~DATA
        ......#....
        ...........
        .#..#.....#
        ........#..
        .....##...#
        #.#.####...
        ..........#
        ...##..#...
        .#.........
        .........#.
        ...#..#....
      DATA
    end

    it 'finds this final state (after 10 rounds)' do
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

    it 'finds this final state (after 20 rounds)' do
      expect(unstable_diffusion.spread_out(22).render).to eq <<~DATA
        .......#......
        ....#......#..
        ..#.....#.....
        ......#.......
        ...#....#.#..#
        #.............
        ....#.....#...
        ..#.....#.....
        ....#.#....#..
        .........#....
        ....#......#..
        .......#......
      DATA
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

  context 'with horizontal line test data' do
    subject(:unstable_diffusion) { described_class.new StringIO.new(<<~DATA) }
      ###
    DATA

    it 'renders the input as expected' do
      expect(unstable_diffusion.render).to eq <<~DATA
        ###
      DATA
    end

    it 'finds this final state' do
      expect(unstable_diffusion.spread_out.render).to eq <<~DATA
        ..#..
        #...#
      DATA
    end

    it 'finds 7 as the number of spaces in the final state' do
      expect(unstable_diffusion.spread_out.count_spaces).to eq 7
    end

    it 'finds 4 as the first round with no moves' do
      expect(unstable_diffusion.part_two).to eq 4
    end
  end

  context 'with cross test data' do
    subject(:unstable_diffusion) { described_class.new StringIO.new(<<~DATA) }
      .#.
      ###
      .#.
    DATA

    it 'renders the input as expected' do
      expect(unstable_diffusion.render).to eq <<~DATA
        .#.
        ###
        .#.
      DATA
    end

    it 'finds this final state' do
      expect(unstable_diffusion.spread_out.render).to eq <<~DATA
        ..#..
        .....
        #.#.#
        .....
        ..#..
      DATA
    end

    it 'finds 20 as the number of spaces in the final state' do
      expect(unstable_diffusion.spread_out.count_spaces).to eq 20
    end

    it 'finds 2 as the first round with no moves' do
      expect(unstable_diffusion.part_two).to eq 2
    end
  end

  context 'with block test data' do
    subject(:unstable_diffusion) { described_class.new StringIO.new(<<~DATA) }
      #####
      #####
      #####
      #####
      #####
    DATA

    it 'renders the input as expected' do
      expect(unstable_diffusion.render).to eq <<~DATA
        #####
        #####
        #####
        #####
        #####
      DATA
    end

    it 'finds this final state' do
      expect(unstable_diffusion.spread_out(15).render).to eq <<~DATA
        ......#..#....
        ...#.......#..
        .....#........
        ..............
        ..#.#.#.#.#..#
        ..............
        #.#.#......#..
        ......#.......
        ...#.....#.#..
        .....##.......
        ......#..#....
        ...#..........
        .....#........
      DATA
    end

    it 'finds 157 as the number of spaces in the final state' do
      expect(unstable_diffusion.spread_out(15).count_spaces).to eq 157
    end

    it 'finds 18 as the first round with no moves' do
      expect(unstable_diffusion.part_two).to eq 18
    end
  end

  context 'with actual input data' do
    subject(:unstable_diffusion) { File.open('input/day23.txt') { |file| described_class.new file } }

    it 'finds 4116 as the number of empty ground tiles after 10 rounds' do
      expect(unstable_diffusion.part_one).to eq 4116
    end

    it 'finds 984 as the first round with no moves' do
      expect(unstable_diffusion.part_two).to eq 984
    end
  end
end
