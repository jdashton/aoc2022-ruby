# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::NotEnoughMinerals do
  context 'with provided test data' do
    subject(:not_enough_minerals) { described_class.new StringIO.new(<<~DATA) }
      Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
      Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
    DATA

    it 'finds 33 is the sum of the quality levels of all of the blueprints in your list' do
      expect(not_enough_minerals.quality_levels).to eq 33
    end
  end

  context 'with actual input data' do
    subject(:not_enough_minerals) { File.open('input/day19.txt') { |file| described_class.new file } }

    it 'finds 33 is the sum of the quality levels of all of the blueprints in your list' do
      expect(not_enough_minerals.quality_levels).to eq 33
    end
  end
end
