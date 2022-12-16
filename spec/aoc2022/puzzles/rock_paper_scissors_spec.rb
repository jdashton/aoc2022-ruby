# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::RockPaperScissors do
  context 'with provided test data' do
    subject(:rock_paper_scissors) { described_class.new StringIO.new(<<~DATA) }
      A Y
      B X
      C Z
    DATA

    it 'finds 15 as the score' do
      expect(rock_paper_scissors.guide_alpha).to eq 15
    end

    it 'finds 12 as the score with better understanding' do
      expect(rock_paper_scissors.guide_beta).to eq 12
    end
  end

  context 'with actual input data' do
    subject(:rock_paper_scissors) { File.open('input/day02.txt') { |file| described_class.new file } }

    it 'finds 14,069 as the score' do
      expect(rock_paper_scissors.guide_alpha).to eq 14_069
    end

    it 'finds 12,411 as the score with better understanding' do
      expect(rock_paper_scissors.guide_beta).to eq 12_411
    end
  end
end
