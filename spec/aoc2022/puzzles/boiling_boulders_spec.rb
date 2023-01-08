# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::BoilingBoulders do
  context 'with provided test data' do
    subject(:boiling_boulders) { described_class.new StringIO.new(<<~DATA) }
      1,1,1
      2,1,1
    DATA

    it 'finds 10 as the number of faces' do
      expect(boiling_boulders.part_one).to eq 10
    end
  end

  context 'with larger test data' do
    subject(:boiling_boulders) { described_class.new StringIO.new(<<~DATA) }
      2,2,2
      1,2,2
      3,2,2
      2,1,2
      2,3,2
      2,2,1
      2,2,3
      2,2,4
      2,2,6
      1,2,5
      3,2,5
      2,1,5
      2,3,5
    DATA

    it 'finds 64 as the number of faces' do
      expect(boiling_boulders.part_one).to eq 64
    end

    it 'finds 58 as the number of exterior faces' do
      expect(boiling_boulders.part_two).to eq 58
    end
  end

  context 'with actual input data' do
    subject(:boiling_boulders) { File.open('input/day18.txt') { |file| described_class.new file } }

    it 'finds 4444 as the number of faces' do
      expect(boiling_boulders.part_one).to eq 4444
    end

    it 'finds 2530 as the number of exterior faces' do
      expect(boiling_boulders.part_two).to eq 2530
    end
  end
end
