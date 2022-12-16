# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::HillClimbingAlgorithm do
  context 'with provided test data' do
    subject(:hill_climbing_algorithm) { described_class.new StringIO.new(<<~DATA) }
      Sabqponm
      abcryxxl
      accszExk
      acctuvwj
      abdefghi
    DATA

    it 'finds 31 as the fewest steps required' do
      expect(hill_climbing_algorithm.fewest_steps).to eq 31
    end

    it "finds 29 as the fewest steps required from 'E' to 'a'" do
      expect(hill_climbing_algorithm.fewest_steps_downhill).to eq 29
    end
  end

  context 'with actual input data' do
    subject(:hill_climbing_algorithm) { File.open('input/day12.txt') { |file| described_class.new file } }

    it 'finds 534 as the fewest steps required' do
      expect(hill_climbing_algorithm.fewest_steps).to eq 534
    end

    # 524 is too low, 534 is too high, and 532 is too high
    it "finds 525 as the fewest steps required from 'E' to 'a'" do
      expect(hill_climbing_algorithm.fewest_steps_downhill).to eq 525
    end
  end
end
