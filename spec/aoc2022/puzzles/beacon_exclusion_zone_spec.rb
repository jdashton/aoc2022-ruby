# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::BeaconExclusionZone do
  context 'with provided test data' do
    subject(:beacon_exclusion_zone) { described_class.new StringIO.new(<<~DATA) }
      Sensor at x=2, y=18: closest beacon is at x=-2, y=15
      Sensor at x=9, y=16: closest beacon is at x=10, y=16
      Sensor at x=13, y=2: closest beacon is at x=15, y=3
      Sensor at x=12, y=14: closest beacon is at x=10, y=16
      Sensor at x=10, y=20: closest beacon is at x=10, y=16
      Sensor at x=14, y=17: closest beacon is at x=10, y=16
      Sensor at x=8, y=7: closest beacon is at x=2, y=10
      Sensor at x=2, y=0: closest beacon is at x=2, y=10
      Sensor at x=0, y=11: closest beacon is at x=2, y=10
      Sensor at x=20, y=14: closest beacon is at x=25, y=17
      Sensor at x=17, y=20: closest beacon is at x=21, y=22
      Sensor at x=16, y=7: closest beacon is at x=15, y=3
      Sensor at x=14, y=3: closest beacon is at x=15, y=3
      Sensor at x=20, y=1: closest beacon is at x=15, y=3
    DATA

    it 'finds 26 as the number of positions that cannot contain a beacon' do
      expect(beacon_exclusion_zone.check_row(10)).to eq 26
    end

    it 'finds 56,000,011 as the tuning frequency' do
      expect(beacon_exclusion_zone.tuning_frequency(20)).to eq 56_000_011
    end
  end

  context 'with actual input data' do
    subject(:beacon_exclusion_zone) { File.open('input/day15.txt') { |file| described_class.new file } }

    it 'finds 5,144,286 as the number of positions that cannot contain a beacon' do
      expect(beacon_exclusion_zone.check_row(2_000_000)).to eq 5_144_286
    end

    # it 'finds 10,229,191,267,339 as the tuning frequency' do
    #   expect(beacon_exclusion_zone.tuning_frequency(4_000_000)).to eq 10_229_191_267_339
    # end
  end

  describe '#merge_ranges' do
    subject(:beacon_exclusion_zone) { described_class.new StringIO.new(<<~DATA) }
      Sensor at x=2, y=18: closest beacon is at x=-2, y=15
    DATA

    it 'can merge a list of one range' do
      expect(beacon_exclusion_zone.merge_ranges([-2..2])).to eq [-2..2]
    end

    it 'can merge a list of two overlapping ranges' do
      expect(beacon_exclusion_zone.merge_ranges([-2..2, 2..2])).to eq [-2..2]
    end

    it 'can merge a list of two non-overlapping ranges' do
      expect(beacon_exclusion_zone.merge_ranges([-2..2, 4..4])).to eq [-2..2, 4..4]
    end
  end

  describe '#insert_beacons' do
    subject(:beacon_exclusion_zone) { described_class.new StringIO.new(<<~DATA) }
      Sensor at x=2, y=18: closest beacon is at x=-2, y=15
      Sensor at x=9, y=16: closest beacon is at x=10, y=16
      Sensor at x=13, y=2: closest beacon is at x=15, y=3
      Sensor at x=12, y=14: closest beacon is at x=10, y=16
      Sensor at x=10, y=20: closest beacon is at x=10, y=16
      Sensor at x=14, y=17: closest beacon is at x=10, y=16
      Sensor at x=8, y=7: closest beacon is at x=2, y=10
      Sensor at x=2, y=0: closest beacon is at x=2, y=10
      Sensor at x=0, y=11: closest beacon is at x=2, y=10
      Sensor at x=20, y=14: closest beacon is at x=25, y=17
      Sensor at x=17, y=20: closest beacon is at x=21, y=22
      Sensor at x=16, y=7: closest beacon is at x=15, y=3
      Sensor at x=14, y=3: closest beacon is at x=15, y=3
      Sensor at x=20, y=1: closest beacon is at x=15, y=3
    DATA

    it 'can merge a beacon on row 10' do
      expect(beacon_exclusion_zone.insert_beacons([-2..24], 10)).to eq [-2..1, 3..24]
    end
  end
end
