# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::ProboscideaVolcanium do
  context 'with provided test data' do
    subject(:proboscidea_volcanium) { described_class.new StringIO.new(<<~DATA) }
      Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
      Valve BB has flow rate=13; tunnels lead to valves CC, AA
      Valve CC has flow rate=2; tunnels lead to valves DD, BB
      Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
      Valve EE has flow rate=3; tunnels lead to valves FF, DD
      Valve FF has flow rate=0; tunnels lead to valves EE, GG
      Valve GG has flow rate=0; tunnels lead to valves FF, HH
      Valve HH has flow rate=22; tunnel leads to valve GG
      Valve II has flow rate=0; tunnels lead to valves AA, JJ
      Valve JJ has flow rate=21; tunnel leads to valve II
    DATA

    it 'finds 0 as the most pressure you can release in 2 minutes' do
      expect(proboscidea_volcanium.max_release(2)).to eq 0
    end

    it 'finds 20 as the most pressure you can release in 3 minutes' do
      expect(proboscidea_volcanium.max_release(3)).to eq 20
    end

    it 'finds 40 as the most pressure you can release in 4 minutes' do
      expect(proboscidea_volcanium.max_release(4)).to eq 40
    end

    it 'finds 63 as the most pressure you can release in 5 minutes' do
      expect(proboscidea_volcanium.max_release(5)).to eq 63
    end

    it 'finds 93 as the most pressure you can release in 6 minutes' do
      expect(proboscidea_volcanium.max_release(6)).to eq 93
    end

    it 'finds 126 as the most pressure you can release in 7 minutes' do
      expect(proboscidea_volcanium.max_release(7)).to eq 126
    end

    it 'finds 162 as the most pressure you can release in 8 minutes' do
      expect(proboscidea_volcanium.max_release(8)).to eq 162
    end

    it 'finds 203 as the most pressure you can release in 9 minutes' do
      expect(proboscidea_volcanium.max_release(9)).to eq 203
    end

    it 'finds 246 as the most pressure you can release in 10 minutes' do
      expect(proboscidea_volcanium.max_release(10)).to eq 246
    end

    it 'finds 300 as the most pressure you can release in 11 minutes' do
      expect(proboscidea_volcanium.max_release(11)).to eq 300
    end

    it 'finds 354 as the most pressure you can release in 12 minutes' do
      expect(proboscidea_volcanium.max_release(12)).to eq 354
    end

    it 'finds 408 as the most pressure you can release in 13 minutes' do
      expect(proboscidea_volcanium.max_release(13)).to eq 408
    end

    it 'finds 464 as the most pressure you can release in 14 minutes' do
      expect(proboscidea_volcanium.max_release(14)).to eq 464
    end

    it 'finds 520 as the most pressure you can release in 15 minutes' do
      expect(proboscidea_volcanium.max_release(15)).to eq 520
    end

    xit 'finds 579 as the most pressure you can release in 16 minutes' do
      expect(proboscidea_volcanium.max_release(16)).to eq 579
    end

    xit 'finds 638 as the most pressure you can release in 17 minutes' do
      expect(proboscidea_volcanium.max_release(17)).to eq 638
    end

    xit 'finds 700 as the most pressure you can release in 18 minutes' do
      expect(proboscidea_volcanium.max_release(18)).to eq 700
    end

    xit 'finds 776 as the most pressure you can release in 19 minutes' do
      expect(proboscidea_volcanium.max_release(19)).to eq 776
    end

    xit 'finds 852 as the most pressure you can release in 20 minutes' do
      expect(proboscidea_volcanium.max_release(20)).to eq 852
    end

    # it 'finds 1651 as the most pressure you can release in 30 minutes' do
    #   expect(proboscidea_volcanium.max_release(30)).to eq 1651
    # end
  end

  context 'with actual input data' do
    subject(:proboscidea_volcanium) { File.open('input/day16.txt') { |file| described_class.new file } }

    it 'finds 24 as the most pressure you can release in 5 minutes' do
      expect(proboscidea_volcanium.max_release(5)).to eq 24
    end
  end
end
