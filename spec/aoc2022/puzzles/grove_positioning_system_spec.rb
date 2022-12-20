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
      expect(grove_positioning_system.mix).to eq 3
    end
  end

  context 'with actual input data' do
    subject(:grove_positioning_system) { File.open('input/day20.txt') { |file| described_class.new file } }

    it 'finds 23321 as the sum of the three numbers that form the grove coordinates' do
      expect(grove_positioning_system.mix).to eq 23321
    end
  end
end
