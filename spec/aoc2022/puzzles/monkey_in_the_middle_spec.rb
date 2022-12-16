# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::MonkeyInTheMiddle do
  context 'with provided test data' do
    subject(:monkey_in_the_middle) { described_class.new StringIO.new(<<~DATA) }
      Monkey 0:
        Starting items: 79, 98
        Operation: new = old * 19
        Test: divisible by 23
          If true: throw to monkey 2
          If false: throw to monkey 3

      Monkey 1:
        Starting items: 54, 65, 75, 74
        Operation: new = old + 6
        Test: divisible by 19
          If true: throw to monkey 2
          If false: throw to monkey 0

      Monkey 2:
        Starting items: 79, 60, 97
        Operation: new = old * old
        Test: divisible by 13
          If true: throw to monkey 1
          If false: throw to monkey 3

      Monkey 3:
        Starting items: 74
        Operation: new = old + 3
        Test: divisible by 17
          If true: throw to monkey 0
          If false: throw to monkey 1
    DATA

    it 'finds 10,605 as the level of monkey business' do
      expect(monkey_in_the_middle.most_active_monkeys).to eq 10_605
    end

    it 'finds 2,713,310,158 as the level of monkey business' do
      expect(monkey_in_the_middle.ten_thousand_monkeys).to eq 2_713_310_158
    end
  end

  context 'with actual input data' do
    subject(:monkey_in_the_middle) { File.open('input/day11.txt') { |file| described_class.new file } }

    it 'finds 61,005 as the level of monkey business' do
      expect(monkey_in_the_middle.most_active_monkeys).to eq 61_005
    end

    it 'finds 20,567,144,694 as the level of monkey business' do
      expect(monkey_in_the_middle.ten_thousand_monkeys).to eq 20_567_144_694
    end
  end
end
