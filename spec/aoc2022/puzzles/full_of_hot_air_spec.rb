# frozen_string_literal: true

SNAFUS = {
  1           => '1',
  2           => '2',
  3           => '1=',
  4           => '1-',
  5           => '10',
  6           => '11',
  7           => '12',
  8           => '2=',
  9           => '2-',
  10          => '20',
  15          => '1=0',
  20          => '1-0',
  2022        => '1=11-2',
  12_345      => '1-0---0',
  314_159_265 => '1121-1110-1=0'
}.invert.merge(
  {
    '1=-0-2' => 1747,
    '12111'  => 906,
    '2=0='   => 198,
    '21'     => 11,
    '2=01'   => 201,
    '111'    => 31,
    '20012'  => 1257,
    '112'    => 32,
    '1=-1='  => 353,
    '1-12'   => 107,
    '122'    => 37
  }
)

NUMBERS = SNAFUS.invert

RSpec.describe AoC2022::Puzzles::FullOfHotAir do
  context 'with provided test data' do
    subject(:full_of_hot_air) { described_class.new StringIO.new(<<~DATA) }
      1=-0-2
      12111
      2=0=
      21
      2=01
      111
      20012
      112
      1=-1=
      1-12
      12
      1=
      122
    DATA

    it 'finds "2=-1=0" as the SNAFU number to enter' do
      expect(full_of_hot_air.part_one).to eq '2=-1=0'
    end
  end

  describe 'Integer.to_snafu' do
    NUMBERS.each do |int, str|
      it "converts #{ int } to #{ str }" do
        expect(int.to_snafu).to eq str
      end
    end
  end

  describe 'String.to_snafu_i' do
    SNAFUS.each do |str, int|
      it "converts #{ str } to #{ int }" do
        expect(str.to_snafu_i).to eq int
      end
    end
  end

  context 'with actual input data' do
    subject(:full_of_hot_air) { File.open('input/day25.txt') { |file| described_class.new file } }

    it 'finds "121=2=1==0=10=2-20=2" as the SNAFU number to enter' do
      expect(full_of_hot_air.part_one).to eq '121=2=1==0=10=2-20=2'
    end
  end
end
