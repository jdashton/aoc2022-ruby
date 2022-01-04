# frozen_string_literal: true

include AoC2021

RSpec.describe BeaconScanner::Beacon do
  describe "#distance" do
    subject { BeaconScanner::Beacon.new(-618, -824, -621) }

    let(:other) { BeaconScanner::Beacon.new(-537, -823, -458) }

    it "finds the same distance when calculated in either direction" do
      expect(subject.sorted_manhattan_distance(other))
        .to eq other.sorted_manhattan_distance(subject)
    end
  end
end

RSpec.describe BeaconScanner do
  describe "#initialize" do
    subject { BeaconScanner.new StringIO.new(<<~PROBES) }
      --- scanner 0 ---
      404,-588,-901
      528,-643,409

      --- scanner 1 ---
      686,422,578
      605,423,415
      515,917,-361
    PROBES

    it "parses input as expected" do
      expect(subject.scanners.size).to eq 2
      expect(subject.scanners[0].id).to eq 0
      expect(subject.scanners[1].id).to eq 1
      expect(subject.scanners[0].beacons.size).to eq 2
      expect(subject.scanners[1].beacons.size).to eq 3
    end
  end

  context "with the example report" do
    subject { BeaconScanner.new StringIO.new(<<~PROBES) }
      --- scanner 0 ---
      404,-588,-901
      528,-643,409
      -838,591,734
      390,-675,-793
      -537,-823,-458
      -485,-357,347
      -345,-311,381
      -661,-816,-575
      -876,649,763
      -618,-824,-621
      553,345,-567
      474,580,667
      -447,-329,318
      -584,868,-557
      544,-627,-890
      564,392,-477
      455,729,728
      -892,524,684
      -689,845,-530
      423,-701,434
      7,-33,-71
      630,319,-379
      443,580,662
      -789,900,-551
      459,-707,401

      --- scanner 1 ---
      686,422,578
      605,423,415
      515,917,-361
      -336,658,858
      95,138,22
      -476,619,847
      -340,-569,-846
      567,-361,727
      -460,603,-452
      669,-402,600
      729,430,532
      -500,-761,534
      -322,571,750
      -466,-666,-811
      -429,-592,574
      -355,545,-477
      703,-491,-529
      -328,-685,520
      413,935,-424
      -391,539,-444
      586,-435,557
      -364,-763,-893
      807,-499,-711
      755,-354,-619
      553,889,-390

      --- scanner 2 ---
      649,640,665
      682,-795,504
      -784,533,-524
      -644,584,-595
      -588,-843,648
      -30,6,44
      -674,560,763
      500,723,-460
      609,671,-379
      -555,-800,653
      -675,-892,-343
      697,-426,-610
      578,704,681
      493,664,-388
      -671,-858,530
      -667,343,800
      571,-461,-707
      -138,-166,112
      -889,563,-600
      646,-828,498
      640,759,510
      -630,509,768
      -681,-892,-333
      673,-379,-804
      -742,-814,-386
      577,-820,562

      --- scanner 3 ---
      -589,542,597
      605,-692,669
      -500,565,-823
      -660,373,557
      -458,-679,-417
      -488,449,543
      -626,468,-788
      338,-750,-386
      528,-832,-391
      562,-778,733
      -938,-730,414
      543,643,-506
      -524,371,-870
      407,773,750
      -104,29,83
      378,-903,-323
      -778,-728,485
      426,699,580
      -438,-605,-362
      -469,-447,-387
      509,732,623
      647,635,-688
      -868,-804,481
      614,-800,639
      595,780,-596

      --- scanner 4 ---
      727,592,562
      -293,-554,779
      441,611,-461
      -714,465,-776
      -743,427,-804
      -660,-479,-426
      832,-632,460
      927,-485,-438
      408,393,-506
      466,436,-512
      110,16,151
      -258,-428,682
      -393,719,612
      -211,-452,876
      808,-476,-593
      -575,615,604
      -485,667,467
      -680,325,-822
      -627,-443,-432
      872,-547,-609
      833,512,582
      807,604,487
      839,-516,451
      891,-625,532
      -652,-548,-490
      30,-46,-14
    PROBES

    it "finds the expected number of probes" do
      subject.merge_all
      expect(subject.num_beacons).to eq 79
    end

    it "parses input as expected" do
      expect(subject.scanners.size).to eq 5
      expect(subject.scanners[0].id).to eq 0
      expect(subject.scanners[1].id).to eq 1
      expect(subject.scanners[0].beacons.size).to eq 25
      expect(subject.scanners[1].beacons.size).to eq 25
      expect(subject.scanners[2].beacons.size).to eq 26
      expect(subject.scanners[3].beacons.size).to eq 25
      expect(subject.scanners[4].beacons.size).to eq 26
    end

    it "sees common beacons between a scanner and itself (identity)" do
      expect(subject.scanners.first.common(subject.scanners.first)).to be true
    end

    it "finds common beacons between S0 and S1" do
      expect(subject.scanners.first.common(subject.scanners[1])).to be true
    end

    it "finds the pairs of beacons common to S0 and S1" do
      expect(subject.scanners[1].common_beacons(subject.scanners.first))
        .to eq Set[
                 BeaconScanner::Beacon.new(686, 422, 578),
                 BeaconScanner::Beacon.new(605, 423, 415),
                 BeaconScanner::Beacon.new(515, 917, -361),
                 BeaconScanner::Beacon.new(-336, 658, 858),
                 BeaconScanner::Beacon.new(-476, 619, 847),
                 BeaconScanner::Beacon.new(-460, 603, -452),
                 BeaconScanner::Beacon.new(729, 430, 532),
                 BeaconScanner::Beacon.new(-322, 571, 750),
                 BeaconScanner::Beacon.new(-355, 545, -477),
                 BeaconScanner::Beacon.new(413, 935, -424),
                 BeaconScanner::Beacon.new(-391, 539, -444),
                 BeaconScanner::Beacon.new(553, 889, -390)
               ]
    end

    it "finds the pairs of beacons common to S1 and S0" do
      expect(subject.scanners.first.common_beacons(subject.scanners[1]))
        .to eq Set[
                 BeaconScanner::Beacon.new(-618, -824, -621),
                 BeaconScanner::Beacon.new(-537, -823, -458),
                 BeaconScanner::Beacon.new(-447, -329, 318),
                 BeaconScanner::Beacon.new(404, -588, -901),
                 BeaconScanner::Beacon.new(544, -627, -890),
                 BeaconScanner::Beacon.new(528, -643, 409),
                 BeaconScanner::Beacon.new(-661, -816, -575),
                 BeaconScanner::Beacon.new(390, -675, -793),
                 BeaconScanner::Beacon.new(423, -701, 434),
                 BeaconScanner::Beacon.new(-345, -311, 381),
                 BeaconScanner::Beacon.new(459, -707, 401),
                 BeaconScanner::Beacon.new(-485, -357, 347)
               ]
    end

    it "finds 68, -1246, -43 for the location of scanner 1" do
      expect(subject.scanners[1].triangulate(subject.scanners.first))
        .to eq [Matrix[[-1, 0, 0], [0, 1, 0], [0, 0, -1]], Vector[68, -1246, -43]]
    end

    it "finds -20, -1133, 1061 for the location of scanner 4" do
      expect(subject.scanners[4].triangulate(subject.scanners.first))
        .to eq [Matrix[[0, -1, 0], [0, 0, -1], [1, 0, 0]], Vector[-20, -1133, 1061]]
    end

    it "finds 1105, -1205, 1229 for the location of scanner 2" do
      expect(subject.scanners[2].triangulate(subject.scanners.first))
        .to eq [Matrix[[-1, 0, 0], [0, 0, 1], [0, 1, 0]], Vector[1105, -1205, 1229]]
    end

    it "finds -92, -2380, -20 for the location of scanner 3" do
      subject.scanners.first.merge(subject.scanners[1])
      expect(subject.scanners[3].triangulate(subject.scanners[0]))
        .to eq [Matrix[[-1, 0, 0], [0, 1, 0], [0, 0, -1]], Vector[-92, -2380, -20]]
    end

    it "assembles all beacons to a common map" do
      subject.merge_all
      expect(subject.full_map)
        .to eq Set[
                 BeaconScanner::Beacon.new(-892, 524, 684),
                 BeaconScanner::Beacon.new(-876, 649, 763),
                 BeaconScanner::Beacon.new(-838, 591, 734),
                 BeaconScanner::Beacon.new(-789, 900, -551),
                 BeaconScanner::Beacon.new(-739, -1745, 668),
                 BeaconScanner::Beacon.new(-706, -3180, -659),
                 BeaconScanner::Beacon.new(-697, -3072, -689),
                 BeaconScanner::Beacon.new(-689, 845, -530),
                 BeaconScanner::Beacon.new(-687, -1600, 576),
                 BeaconScanner::Beacon.new(-661, -816, -575),
                 BeaconScanner::Beacon.new(-654, -3158, -753),
                 BeaconScanner::Beacon.new(-635, -1737, 486),
                 BeaconScanner::Beacon.new(-631, -672, 1502),
                 BeaconScanner::Beacon.new(-624, -1620, 1868),
                 BeaconScanner::Beacon.new(-620, -3212, 371),
                 BeaconScanner::Beacon.new(-618, -824, -621),
                 BeaconScanner::Beacon.new(-612, -1695, 1788),
                 BeaconScanner::Beacon.new(-601, -1648, -643),
                 BeaconScanner::Beacon.new(-584, 868, -557),
                 BeaconScanner::Beacon.new(-537, -823, -458),
                 BeaconScanner::Beacon.new(-532, -1715, 1894),
                 BeaconScanner::Beacon.new(-518, -1681, -600),
                 BeaconScanner::Beacon.new(-499, -1607, -770),
                 BeaconScanner::Beacon.new(-485, -357, 347),
                 BeaconScanner::Beacon.new(-470, -3283, 303),
                 BeaconScanner::Beacon.new(-456, -621, 1527),
                 BeaconScanner::Beacon.new(-447, -329, 318),
                 BeaconScanner::Beacon.new(-430, -3130, 366),
                 BeaconScanner::Beacon.new(-413, -627, 1469),
                 BeaconScanner::Beacon.new(-345, -311, 381),
                 BeaconScanner::Beacon.new(-36, -1284, 1171),
                 BeaconScanner::Beacon.new(-27, -1108, -65),
                 BeaconScanner::Beacon.new(7, -33, -71),
                 BeaconScanner::Beacon.new(12, -2351, -103),
                 BeaconScanner::Beacon.new(26, -1119, 1091),
                 BeaconScanner::Beacon.new(346, -2985, 342),
                 BeaconScanner::Beacon.new(366, -3059, 397),
                 BeaconScanner::Beacon.new(377, -2827, 367),
                 BeaconScanner::Beacon.new(390, -675, -793),
                 BeaconScanner::Beacon.new(396, -1931, -563),
                 BeaconScanner::Beacon.new(404, -588, -901),
                 BeaconScanner::Beacon.new(408, -1815, 803),
                 BeaconScanner::Beacon.new(423, -701, 434),
                 BeaconScanner::Beacon.new(432, -2009, 850),
                 BeaconScanner::Beacon.new(443, 580, 662),
                 BeaconScanner::Beacon.new(455, 729, 728),
                 BeaconScanner::Beacon.new(456, -540, 1869),
                 BeaconScanner::Beacon.new(459, -707, 401),
                 BeaconScanner::Beacon.new(465, -695, 1988),
                 BeaconScanner::Beacon.new(474, 580, 667),
                 BeaconScanner::Beacon.new(496, -1584, 1900),
                 BeaconScanner::Beacon.new(497, -1838, -617),
                 BeaconScanner::Beacon.new(527, -524, 1933),
                 BeaconScanner::Beacon.new(528, -643, 409),
                 BeaconScanner::Beacon.new(534, -1912, 768),
                 BeaconScanner::Beacon.new(544, -627, -890),
                 BeaconScanner::Beacon.new(553, 345, -567),
                 BeaconScanner::Beacon.new(564, 392, -477),
                 BeaconScanner::Beacon.new(568, -2007, -577),
                 BeaconScanner::Beacon.new(605, -1665, 1952),
                 BeaconScanner::Beacon.new(612, -1593, 1893),
                 BeaconScanner::Beacon.new(630, 319, -379),
                 BeaconScanner::Beacon.new(686, -3108, -505),
                 BeaconScanner::Beacon.new(776, -3184, -501),
                 BeaconScanner::Beacon.new(846, -3110, -434),
                 BeaconScanner::Beacon.new(1135, -1161, 1235),
                 BeaconScanner::Beacon.new(1243, -1093, 1063),
                 BeaconScanner::Beacon.new(1660, -552, 429),
                 BeaconScanner::Beacon.new(1693, -557, 386),
                 BeaconScanner::Beacon.new(1735, -437, 1738),
                 BeaconScanner::Beacon.new(1749, -1800, 1813),
                 BeaconScanner::Beacon.new(1772, -405, 1572),
                 BeaconScanner::Beacon.new(1776, -675, 371),
                 BeaconScanner::Beacon.new(1779, -442, 1789),
                 BeaconScanner::Beacon.new(1780, -1548, 337),
                 BeaconScanner::Beacon.new(1786, -1538, 337),
                 BeaconScanner::Beacon.new(1847, -1591, 415),
                 BeaconScanner::Beacon.new(1889, -1729, 1762),
                 BeaconScanner::Beacon.new(1994, -1805, 1792)
               ]
    end

    it "finds the largest distance is 3621" do
      subject.merge_all
      expect(subject.largest_distance).to eq 3621
    end
  end
end
