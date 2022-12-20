# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::PyroclasticFlow do
  context 'with provided test data' do
    subject(:pyroclastic_flow) { described_class.new StringIO.new(<<~DATA) }
      >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
    DATA

    it 'finds 3068 units is the height after 2022 rocks' do
      expect(pyroclastic_flow.drop_rocks).to eq 3068
    end
  end

  context 'with actual input data' do
    subject(:pyroclastic_flow) { File.open('input/day17.txt') { |file| described_class.new file } }

    it 'finds 3068 units is the height after 2022 rocks' do
      expect(pyroclastic_flow.drop_rocks).to eq 3068
    end
  end
end
