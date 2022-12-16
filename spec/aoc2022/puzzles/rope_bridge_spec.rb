# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::RopeBridge do
  context 'with provided test data' do
    subject(:rope_bridge) { described_class.new StringIO.new(<<~DATA) }
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
    DATA

    it 'finds 13 as the number of positions visited by the tail at least once' do
      expect(rope_bridge.short_positions).to eq 13
    end

    it 'finds 1 as the number of positions visited by the tail at least once' do
      expect(rope_bridge.long_positions).to eq 1
    end
  end

  context 'with provided test data version 2' do
    subject(:rope_bridge) { described_class.new StringIO.new(<<~DATA) }
      R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20
    DATA

    it 'finds 36 as the number of positions visited by the tail at least once' do
      expect(rope_bridge.long_positions).to eq 36
    end
  end

  context 'with actual input data' do
    subject(:rope_bridge) { File.open('input/day09.txt') { |file| described_class.new file } }

    # 6388 is too high.
    it 'finds 6384 as the number of positions visited by the tail at least once' do
      expect(rope_bridge.short_positions).to eq 6384
    end

    it 'finds 2734 as the number of positions visited by the tail at least once' do
      expect(rope_bridge.long_positions).to eq 2734
    end
  end
end
