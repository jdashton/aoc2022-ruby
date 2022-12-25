# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::BlizzardBasin do
  context 'with provided test data' do
    subject(:blizzard_basin) { described_class.new StringIO.new(<<~DATA) }
      #.#####
      #.....#
      #>....#
      #.....#
      #...v.#
      #.....#
      #####.#
    DATA

    it 'finds "18" as the fewest number of minutes required to avoid the blizzards and reach the goal' do
      expect(blizzard_basin.part_one).to eq 18
    end
  end

  context 'with actual input data' do
    subject(:blizzard_basin) { File.open('input/day24.txt') { |file| described_class.new file } }

    it 'finds "18" as the fewest number of minutes required to avoid the blizzards and reach the goal' do
      expect(blizzard_basin.part_one).to eq 18
    end
  end
end
