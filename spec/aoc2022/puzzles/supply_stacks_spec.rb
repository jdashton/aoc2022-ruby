# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::SupplyStacks do
  context 'with provided test data' do
    # rubocop:disable Lint/LiteralInInterpolation
    subject(:supply_stacks) { described_class.new StringIO.new(<<~DATA) }
          [D]#{ '    ' }
      [N] [C]#{ '    ' }
      [Z] [M] [P]
       1   2   3#{ ' ' }

      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
    DATA
    # rubocop:enable Lint/LiteralInInterpolation

    it 'finds CMZ as the top crates after all instructions' do
      expect(supply_stacks.top_crates).to eq 'CMZ'
    end

    it 'finds MCD as the top crates after all instructions' do
      expect(supply_stacks.top_crates_9001).to eq 'MCD'
    end
  end

  context 'with actual input data' do
    subject(:supply_stacks) { File.open('input/day05.txt') { |file| described_class.new file } }

    it 'finds SPFMVDTZT as the top crates after all instructions' do
      expect(supply_stacks.top_crates).to eq 'SPFMVDTZT'
    end

    it 'finds ZFSJBPRFP as the top crates after all instructions' do
      expect(supply_stacks.top_crates_9001).to eq 'ZFSJBPRFP'
    end
  end
end
