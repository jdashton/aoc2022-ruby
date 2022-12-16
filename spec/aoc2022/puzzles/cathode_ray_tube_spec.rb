# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::CathodeRayTube do
  context 'with provided test data' do
    subject(:cathode_ray_tube) { described_class.new StringIO.new(<<~DATA) }
      addx 15
      addx -11
      addx 6
      addx -3
      addx 5
      addx -1
      addx -8
      addx 13
      addx 4
      noop
      addx -1
      addx 5
      addx -1
      addx 5
      addx -1
      addx 5
      addx -1
      addx 5
      addx -1
      addx -35
      addx 1
      addx 24
      addx -19
      addx 1
      addx 16
      addx -11
      noop
      noop
      addx 21
      addx -15
      noop
      noop
      addx -3
      addx 9
      addx 1
      addx -3
      addx 8
      addx 1
      addx 5
      noop
      noop
      noop
      noop
      noop
      addx -36
      noop
      addx 1
      addx 7
      noop
      noop
      noop
      addx 2
      addx 6
      noop
      noop
      noop
      noop
      noop
      addx 1
      noop
      noop
      addx 7
      addx 1
      noop
      addx -13
      addx 13
      addx 7
      noop
      addx 1
      addx -33
      noop
      noop
      noop
      addx 2
      noop
      noop
      noop
      addx 8
      noop
      addx -1
      addx 2
      addx 1
      noop
      addx 17
      addx -9
      addx 1
      addx 1
      addx -3
      addx 11
      noop
      noop
      addx 1
      noop
      addx 1
      noop
      noop
      addx -13
      addx -19
      addx 1
      addx 3
      addx 26
      addx -30
      addx 12
      addx -1
      addx 3
      addx 1
      noop
      noop
      noop
      addx -9
      addx 18
      addx 1
      addx 2
      noop
      noop
      addx 9
      noop
      noop
      noop
      addx -1
      addx 2
      addx -37
      addx 1
      addx 3
      noop
      addx 15
      addx -21
      addx 22
      addx -6
      addx 1
      noop
      addx 2
      addx 1
      noop
      addx -10
      noop
      noop
      addx 20
      addx 1
      addx 2
      addx 2
      addx -6
      addx -11
      noop
      noop
      noop
    DATA

    it 'finds 13,140 as the sum of the six signal strengths' do
      expect(cathode_ray_tube.sum_of_six_strengths).to eq 13_140
    end

    it 'generates the expected pattern' do
      expect(cathode_ray_tube.render_image).to eq <<~IMAGE
        ##..##..##..##..##..##..##..##..##..##..
        ###...###...###...###...###...###...###.
        ####....####....####....####....####....
        #####.....#####.....#####.....#####.....
        ######......######......######......####
        #######.......#######.......#######.....
      IMAGE
    end
  end

  context 'with actual input data' do
    subject(:cathode_ray_tube) { File.open('input/day10.txt') { |file| described_class.new file } }

    it 'finds 14,060 as the sum of the six signal strengths' do
      expect(cathode_ray_tube.sum_of_six_strengths).to eq 14_060
    end

    # PAPKFKEJ
    it 'generates the expected letters' do
      expect(cathode_ray_tube.render_image).to eq <<~IMAGE
        ###...##..###..#..#.####.#..#.####...##.
        #..#.#..#.#..#.#.#..#....#.#..#.......#.
        #..#.#..#.#..#.##...###..##...###.....#.
        ###..####.###..#.#..#....#.#..#.......#.
        #....#..#.#....#.#..#....#.#..#....#..#.
        #....#..#.#....#..#.#....#..#.####..##..
      IMAGE
    end
  end
end
