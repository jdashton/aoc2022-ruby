# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::GrovePositioningSystem do
  context 'with provided test data' do
    subject(:grove_positioning_system) { described_class.new StringIO.new(<<~DATA) }
      1
      2
      -3
      3
      -2
      0
      4
    DATA

    it 'finds 3 as the sum of the three numbers that form the grove coordinates' do
      expect(grove_positioning_system.part_one).to eq 3
    end

    it 'finds 1,623,178,306 as the sum of the three numbers that form the grove coordinates' do
      expect(grove_positioning_system.part_two).to eq 1_623_178_306
    end
  end

  context 'with actual input data' do
    subject(:grove_positioning_system) { File.open('input/day20.txt') { |file| described_class.new file } }

    it 'finds 23,321 as the sum of the three numbers that form the grove coordinates' do
      expect(grove_positioning_system.part_one).to eq 23_321
    end

    it 'finds 1,428,396,909,280 as the sum of the three numbers that form the grove coordinates' do
      expect(grove_positioning_system.part_two).to eq 1_428_396_909_280
    end
  end
end
