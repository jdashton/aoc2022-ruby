# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::RucksackReorganization do
  context 'with provided test data' do
    subject(:rucksacks) { described_class.new StringIO.new(<<~DATA) }
      vJrwpWtwJgWrhcsFMMfFFhFp
      jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
      PmmdzqPrVvPwwTWBwg
      wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
      ttgJtRGJQctTZtZT
      CrZsJsPPZsGzwwsLwLmpwMDw
    DATA

    it 'finds 157 as the sum of the priorities' do
      expect(rucksacks.priority_sum).to eq 157
    end

    it 'finds 70 as the sum of the badge priorities' do
      expect(rucksacks.badge_sum).to eq 70
    end
  end

  context 'with actual input data' do
    subject(:rucksacks) { File.open('input/day03.txt') { |file| described_class.new file } }

    it 'finds 7,746 as the sum of the priorities' do
      expect(rucksacks.priority_sum).to eq 7_746
    end

    it 'finds 2,604 as the sum of the badge priorities' do
      expect(rucksacks.badge_sum).to eq 2_604
    end
  end
end
