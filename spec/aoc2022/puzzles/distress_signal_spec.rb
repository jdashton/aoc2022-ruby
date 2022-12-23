# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::DistressSignal do
  context 'with provided test data' do
    subject(:distress_signal) { described_class.new StringIO.new(<<~DATA) }
      [1,1,3,1,1]
      [1,1,5,1,1]

      [[1],[2,3,4]]
      [[1],4]

      [9]
      [[8,7,6]]

      [[4,4],4,4]
      [[4,4],4,4,4]

      [7,7,7,7]
      [7,7,7]

      []
      [3]

      [[[]]]
      [[]]

      [1,[2,[3,[4,[5,6,7]]]],8,9]
      [1,[2,[3,[4,[5,6,0]]]],8,9]
    DATA

    it 'finds 13 as the sum of the indices of pairs that are in the right order' do
      expect(distress_signal.check_order).to eq 13
    end

    it 'finds 140 as the decoder key' do
      expect(distress_signal.decoder_key).to eq 140
    end
  end

  context 'with actual input data' do
    subject(:distress_signal) { File.open('input/day13.txt') { |file| described_class.new file } }

    xit 'finds 5,393 as the sum of the indices of pairs that are in the right order' do
      expect(distress_signal.check_order).to eq 5_393
    end

    # 27216 is too high.
    it 'finds 26,712 as the decoder key' do
      expect(distress_signal.decoder_key).to eq 26_712
    end
  end
end
