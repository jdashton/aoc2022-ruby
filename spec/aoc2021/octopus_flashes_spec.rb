# frozen_string_literal: true

require "rspec"

require "aoc2021/puzzles/octopus_flashes"

RSpec.describe AoC2021::OctopusFlashes do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context "with small input" do
    subject { AoC2021::OctopusFlashes.new StringIO.new(<<~BITS) }
      11111
      19991
      19191
      19991
      11111
    BITS

    describe "#total" do
      it "finds 9 flashes after 1 steps" do
        expect(subject.total(1)).to eq 9
      end

      it "finds 9 flashes after 2 steps" do
        expect(subject.total(2)).to eq 9
      end
    end

    describe "#next_board" do
      it "can report a board as a string" do
        expect(subject.next_board(0).to_s).to eq <<~BITS
          11111
          19991
          19191
          19991
          11111
        BITS
      end

      it "finds the expected board after 1 step" do
        expect(subject.next_board(1).to_s).to eq <<~BITS
          34543
          40004
          50005
          40004
          34543
        BITS
      end

      it "finds the expected board after 2 steps" do
        expect(subject.next_board(2).to_s).to eq <<~BITS
          45654
          51115
          61116
          51115
          45654
        BITS
      end
    end
  end

  context "with provided input" do
    subject { AoC2021::OctopusFlashes.new StringIO.new(<<~BITS) }
      5483143223
      2745854711
      5264556173
      6141336146
      6357385478
      4167524645
      2176841721
      6882881134
      4846848554
      5283751526
    BITS

    describe "#total" do
      it "can report a board as a string" do
        expect(subject.next_board(0).to_s).to eq <<~BITS
          5483143223
          2745854711
          5264556173
          6141336146
          6357385478
          4167524645
          2176841721
          6882881134
          4846848554
          5283751526
        BITS
      end

      it "finds the expected board after 1 step" do
        expect(subject.next_board(1).to_s).to eq <<~BITS
          6594254334
          3856965822
          6375667284
          7252447257
          7468496589
          5278635756
          3287952832
          7993992245
          5957959665
          6394862637
        BITS
      end

      it "finds the expected board after 2 steps" do
        expect(subject.next_board(2).to_s).to eq <<~BITS
          8807476555
          5089087054
          8597889608
          8485769600
          8700908800
          6600088989
          6800005943
          0000007456
          9000000876
          8700006848
        BITS
      end

      it "finds the expected board after 3 step" do
        expect(subject.next_board(3).to_s).to eq <<~BITS
          0050900866
          8500800575
          9900000039
          9700000041
          9935080063
          7712300000
          7911250009
          2211130000
          0421125000
          0021119000
        BITS
      end

      it "finds the expected board after 4 steps" do
        expect(subject.next_board(4).to_s).to eq <<~BITS
          2263031977
          0923031697
          0032221150
          0041111163
          0076191174
          0053411122
          0042361120
          5532241122
          1532247211
          1132230211
        BITS
      end

      it "finds the expected board after 5 step" do
        expect(subject.next_board(5).to_s).to eq <<~BITS
          4484144000
          2044144000
          2253333493
          1152333274
          1187303285
          1164633233
          1153472231
          6643352233
          2643358322
          2243341322
        BITS
      end

      it "finds the expected board after 6 steps" do
        expect(subject.next_board(6).to_s).to eq <<~BITS
          5595255111
          3155255222
          3364444605
          2263444496
          2298414396
          2275744344
          2264583342
          7754463344
          3754469433
          3354452433
        BITS
      end

      it "finds the expected board after 7 step" do
        expect(subject.next_board(7).to_s).to eq <<~BITS
          6707366222
          4377366333
          4475555827
          3496655709
          3500625609
          3509955566
          3486694453
          8865585555
          4865580644
          4465574644
        BITS
      end

      it "finds the expected board after 8 steps" do
        expect(subject.next_board(8).to_s).to eq <<~BITS
          7818477333
          5488477444
          5697666949
          4608766830
          4734946730
          4740097688
          6900007564
          0000009666
          8000004755
          6800007755
        BITS
      end

      it "finds the expected board after 9 step" do
        expect(subject.next_board(9).to_s).to eq <<~BITS
          9060000644
          7800000976
          6900000080
          5840000082
          5858000093
          6962400000
          8021250009
          2221130009
          9111128097
          7911119976
        BITS
      end

      it "finds the expected board after 10 steps" do
        expect(subject.next_board(10).to_s).to eq <<~BITS
          0481112976
          0031112009
          0041112504
          0081111406
          0099111306
          0093511233
          0442361130
          5532252350
          0532250600
          0032240000
        BITS
      end

      it "finds the expected board after 20 step" do
        expect(subject.next_board(20).to_s).to eq <<~BITS
          3936556452
          5686556806
          4496555690
          4448655580
          4456865570
          5680086577
          7000009896
          0000000344
          6000000364
          4600009543
        BITS
      end

      it "finds the expected board after 30 steps" do
        expect(subject.next_board(30).to_s).to eq <<~BITS
          0643334118
          4253334611
          3374333458
          2225333337
          2229333338
          2276733333
          2754574565
          5544458511
          9444447111
          7944446119
        BITS
      end

      it "finds the expected board after 40 step" do
        expect(subject.next_board(40).to_s).to eq <<~BITS
          6211111981
          0421111119
          0042111115
          0003111115
          0003111116
          0065611111
          0532351111
          3322234597
          2222222976
          2222222762
        BITS
      end

      it "finds the expected board after 50 steps" do
        expect(subject.next_board(50).to_s).to eq <<~BITS
          9655556447
          4865556805
          4486555690
          4458655580
          4574865570
          5700086566
          6000009887
          8000000533
          6800000633
          5680000538
        BITS
      end

      it "finds the expected board after 60 step" do
        expect(subject.next_board(60).to_s).to eq <<~BITS
          2533334200
          2743334640
          2264333458
          2225333337
          2225333338
          2287833333
          3854573455
          1854458611
          1175447111
          1115446111
        BITS
      end

      it "finds the expected board after 70 steps" do
        expect(subject.next_board(70).to_s).to eq <<~BITS
          8211111164
          0421111166
          0042111114
          0004211115
          0000211116
          0065611111
          0532351111
          7322235117
          5722223475
          4572222754
        BITS
      end

      it "finds the expected board after 80 steps" do
        expect(subject.next_board(80).to_s).to eq <<~BITS
          1755555697
          5965555609
          4486555680
          4458655580
          4570865570
          5700086566
          7000008666
          0000000990
          0000000800
          0000000000
        BITS
      end

      it "finds the expected board after 90 steps" do
        expect(subject.next_board(90).to_s).to eq <<~BITS
          7433333522
          2643333522
          2264333458
          2226433337
          2222433338
          2287833333
          2854573333
          4854458333
          3387779333
          3333333333
        BITS
      end

      it "finds the expected board after 100 steps" do
        expect(subject.next_board(100).to_s).to eq <<~BITS
          0397666866
          0749766918
          0053976933
          0004297822
          0004229892
          0053222877
          0532222966
          9322228966
          7922286866
          6789998766
        BITS
      end

      it "finds 0 flashes after 1 step" do
        expect(subject.total(1)).to eq 0
      end

      it "finds 35 flashes after 2 steps" do
        expect(subject.total(2)).to eq 35
      end

      it "finds 80 flashes after 3 steps" do
        expect(subject.total(3)).to eq 80
      end

      it "finds 96 flashes after 4 steps" do
        expect(subject.total(4)).to eq 96
      end

      it "finds 104 flashes after 5 steps" do
        expect(subject.total(5)).to eq 104
      end

      it "finds 105 flashes after 6 steps" do
        expect(subject.total(6)).to eq 105
      end

      it "finds 112 flashes after 7 steps" do
        expect(subject.total(7)).to eq 112
      end

      it "finds 136 flashes after 8 steps" do
        expect(subject.total(8)).to eq 136
      end

      it "finds 175 flashes after 9 steps" do
        expect(subject.total(9)).to eq 175
      end

      it "finds 204 flashes after 10 steps" do
        expect(subject.total(10)).to eq 204
      end

      it "finds 1656 flashes after 100 steps" do
        expect(subject.total(100)).to eq 1656
      end
    end
    describe "#synchronized_at" do
      it "finds synchronization at step 195" do
        expect(subject.synchronized_at).to eq 195
      end
    end
  end
end
