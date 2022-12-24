# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::MonkeyMap do
  context 'with provided test data' do
    subject(:monkey_map) { described_class.new StringIO.new(<<~DATA) }
              ...#
              .#..
              #...
              ....
      ...#.......#
      ........#...
      ..#....#....
      ..........#.
              ...#....
              .....#..
              .#......
              ......#.

      10R5L5R10L4R5L5
    DATA

    it 'finds 6032 as the final password' do
      expect(monkey_map.part_one).to eq 6032
    end

    it 'finds 5031 as the final password' do
      expect(monkey_map.part_two).to eq 5031
    end
  end

  context 'with actual input data' do
    subject(:monkey_map) { File.open('input/day22.txt') { |file| described_class.new file } }

    # 4346 is (far) too low
    it 'finds 73,346 as the final password' do
      expect(monkey_map.part_one).to eq 73_346
    end

    # 50538 is too low
    # 195075 is too high
    it 'finds 106,392 as the final password' do
      expect(monkey_map.part_two).to eq 106_392
    end
  end
end
