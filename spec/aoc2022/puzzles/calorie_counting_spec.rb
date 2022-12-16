# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::CalorieCounting do
  context 'with provided test data' do
    subject(:elf_calories) { described_class.new StringIO.new(<<~NUMBERS) }
      1000
      2000
      3000

      4000

      5000
      6000

      7000
      8000
      9000

      10000
    NUMBERS

    it 'finds 24,000 as the highest calorie count' do
      expect(elf_calories.most_calories).to eq 24_000
    end

    it 'finds 45,000 as the calorie some for the top 3 elves' do
      expect(elf_calories.top_3_total).to eq 45_000
    end
  end

  context 'with actual input data' do
    subject(:elf_calories) { File.open('input/day01.txt') { |file| described_class.new file } }

    it 'finds 74,711 as the highest calorie count' do
      expect(elf_calories.most_calories).to eq 74_711
    end

    it 'finds 209,481 as the calorie some for the top 3 elves' do
      expect(elf_calories.top_3_total).to eq 209_481
    end
  end
end
