# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::MonkeyMath do
  context 'with provided test data' do
    subject(:monkey_math) { described_class.new StringIO.new(<<~DATA) }
      root: pppw + sjmn
      dbpl: 5
      cczh: sllz + lgvd
      zczc: 2
      ptdq: humn - dvpt
      dvpt: 3
      lfqf: 4
      humn: 5
      ljgn: 2
      sjmn: drzm * dbpl
      sllz: 4
      pppw: cczh / lfqf
      lgvd: ljgn * ptdq
      drzm: hmdt - zczc
      hmdt: 32
    DATA

    it 'finds 152 as the number that root will yell' do
      expect(monkey_math.find_advanced(:root)).to eq 152
    end

    it 'finds 301 as the number I must yell' do
      expect(monkey_math.part_two).to eq 301
    end
  end

  context 'with actual input data' do
    subject(:monkey_math) { File.open('input/day21.txt') { |file| described_class.new file } }

    it 'finds 142,707,821,472,432 as the number that root will yell' do
      expect(monkey_math.find_advanced(:root)).to eq 142_707_821_472_432
    end

    # 8759966720571 is too high
    it 'finds 3,587,647,562,851 as the number I must yell' do
      expect(monkey_math.part_two).to eq 3_587_647_562_851
    end
  end
end
