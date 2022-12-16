# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::CampCleanup do
  context 'with provided test data' do
    subject(:cleanup) { described_class.new StringIO.new(<<~DATA) }
      2-4,6-8
      2-3,4-5
      5-7,7-9
      2-8,3-7
      6-6,4-6
      2-6,4-8
    DATA

    it 'finds 2 as the number of fully-contained ranges' do
      expect(cleanup.contained_ranges).to eq 2
    end

    it 'finds 4 as the number of overlapping ranges' do
      expect(cleanup.overlapping_ranges).to eq 4
    end
  end

  context 'with actual input data' do
    subject(:cleanup) { File.open('input/day04.txt') { |file| described_class.new file } }

    it 'finds 448 as the number of fully-contained ranges' do
      expect(cleanup.contained_ranges).to eq 448
    end

    it 'finds 794 as the number of overlapping ranges' do
      expect(cleanup.overlapping_ranges).to eq 794
    end
  end
end
