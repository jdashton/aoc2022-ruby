# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::TreetopTreeHouse do
  context 'with provided test data' do
    subject(:treetop_tree_house) { described_class.new StringIO.new(<<~DATA) }
      30373
      25512
      65332
      33549
      35390
    DATA

    it 'finds 21 visible trees' do
      expect(treetop_tree_house.visible).to eq 21
    end

    it 'finds 8 as the highest possible scenic score' do
      expect(treetop_tree_house.scenic_score).to eq 8
    end
  end

  context 'with actual input data' do
    subject(:treetop_tree_house) { File.open('input/day08.txt') { |file| described_class.new file } }

    it 'finds 1538 visible trees' do
      expect(treetop_tree_house.visible).to eq 1538
    end

    # 665600 is too high
    it 'finds 496,125 as the highest possible scenic score' do
      expect(treetop_tree_house.scenic_score).to eq 496_125
    end
  end
end
