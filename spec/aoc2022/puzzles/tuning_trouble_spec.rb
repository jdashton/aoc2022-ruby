# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::TuningTrouble do
  context 'with provided test data' do
    subject(:tuning_trouble) { described_class.new StringIO.new(<<~DATA) }
      mjqjpqmgbljsphdztnvjfqwrcgsmlb
    DATA

    it 'finds 7 as the end of the start-of-packet marker' do
      expect(tuning_trouble.packet_marker).to eq 7
    end

    it 'finds 19 as the end of the start-of-packet marker' do
      expect(tuning_trouble.message_marker).to eq 19
    end
  end

  context 'with actual input data' do
    subject(:tuning_trouble) { File.open('input/day06.txt') { |file| described_class.new file } }

    it 'finds 1566 as the top crates after all instructions' do
      expect(tuning_trouble.packet_marker).to eq 1566
    end

    it 'finds 2265 as the top crates after all instructions' do
      expect(tuning_trouble.message_marker).to eq 2265
    end
  end
end
