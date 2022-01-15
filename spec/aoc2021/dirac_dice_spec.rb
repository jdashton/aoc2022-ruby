# frozen_string_literal: true

require "aoc2021/puzzles/trench_map"
include AoC2021

RSpec.describe DiracDice do
  describe "#deterministic_die" do
    subject { DiracDice.new StringIO.new(<<~NUMBERS) }
      Player 1 starting position: 4
      Player 2 starting position: 8
    NUMBERS

    it "find an answer of 1073709" do
      expect(subject.deterministic_die).to eq "897 * 1197 = 1073709"
    end
  end

  describe "DiracDice::State" do
    it "packs and unpacks as expected: (9, 0), (3, 0)" do
      unpacked = DiracDice::State.unpack(DiracDice::State.new(DiracDice::Player.new(9), DiracDice::Player.new(3)).pack)
      expect([unpacked.player1.position_adjusted,
              unpacked.player1.score,
              unpacked.player2.position_adjusted,
              unpacked.player2.score])
        .to eq [9, 0, 3, 0]
    end

    it "packs and unpacks as expected: (20, 5), (22, 2)" do
      unpacked = DiracDice::State.unpack(DiracDice::State.new(DiracDice::Player.new(5, 20), DiracDice::Player.new(2, 22)).pack)
      expect([unpacked.player1.position_adjusted,
              unpacked.player1.score,
              unpacked.player2.position_adjusted,
              unpacked.player2.score])
        .to eq [5, 20, 2, 22]
    end

    it "should pack/unpack as expected" do
      (0..20).each do |p1_score|
        (1..10).each do |p1_pos|
          (0..20).each do |p2_score|
            (1..10).each do |p2_pos|
              unpacked = DiracDice::State.unpack(DiracDice::State.new(DiracDice::Player.new(p1_pos, p1_score), DiracDice::Player.new(p2_pos, p2_score)).pack)
              expect([unpacked.player1.position_adjusted,
                      unpacked.player1.score,
                      unpacked.player2.position_adjusted,
                      unpacked.player2.score])
                .to eq [p1_pos, p1_score, p2_pos, p2_score]
            end
          end
        end
      end
    end
  end

  describe "#dirac_to_score" do
    context "with example input" do
      subject { DiracDice.new StringIO.new(<<~NUMBERS) }
        Player 1 starting position: 4
        Player 2 starting position: 8
      NUMBERS

      it "gets the expected results for wins at 1 point" do
        expect(subject.dirac_to_score(1)).to eq [27, 0]
      end

      it "gets the expected results for wins at 2 points" do
        expect(subject.dirac_to_score(2)).to eq [183, 156]
      end

      it "gets the expected results for wins at 3 points" do
        expect(subject.dirac_to_score(3)).to eq [990, 207]
      end

      it "gets the expected results for wins at 4 points" do
        expect(subject.dirac_to_score(4)).to eq [2930, 971]
      end

      it "gets the expected results for wins at 5 points" do
        expect(subject.dirac_to_score(5)).to eq [7907, 2728]
      end

      it "gets the expected results for wins at 6 points" do
        expect(subject.dirac_to_score(6)).to eq [30_498, 7203]
      end

      it "gets the expected results for wins at 7 points" do
        expect(subject.dirac_to_score(7)).to eq [127_019, 152_976]
      end

      it "gets the expected results for wins at 8 points" do
        expect(subject.dirac_to_score(8)).to eq [655_661, 1_048_978]
      end

      it "gets the expected results for wins at 9 points" do
        expect(subject.dirac_to_score(9)).to eq [4_008_007, 4_049_420]
      end

      it "gets the expected results for wins at 10 points" do
        expect(subject.dirac_to_score(10)).to eq [18_973_591, 12_657_100]
      end

      it "gets the expected results for wins at 11 point" do
        expect(subject.dirac_to_score(11)).to eq [90_197_150, 47_304_735]
      end

      it "gets the expected results for wins at 12 points" do
        expect(subject.dirac_to_score(12)).to eq [454_323_519, 217_150_220]
      end

      it "gets the expected results for wins at 13 points" do
        expect(subject.dirac_to_score(13)).to eq [2_159_295_972, 1_251_104_269]
      end

      it "gets the expected results for wins at 14 points" do
        expect(subject.dirac_to_score(14)).to eq [9_632_852_745, 7_543_855_038]
      end

      it "gets the expected results for wins at 15 points" do
        expect(subject.dirac_to_score(15)).to eq [43_413_388_231, 37_334_719_860]
      end

      it "gets the expected results for wins at 16 points" do
        expect(subject.dirac_to_score(16)).to eq [199_092_281_721, 161_946_691_198]
      end

      it "gets the expected results for wins at 17 points" do
        expect(subject.dirac_to_score(17)).to eq [903_307_715_712, 698_632_570_521]
      end

      it "gets the expected results for wins at 18 points" do
        expect(subject.dirac_to_score(18)).to eq [4_227_532_541_969, 3_151_502_992_942]
      end

      it "gets the expected results for wins at 19 points" do
        expect(subject.dirac_to_score(19)).to eq [20_259_464_849_183, 14_795_269_706_204]
      end

      it "gets the expected results for wins at 20 points" do
        expect(subject.dirac_to_score(20)).to eq [95_627_706_087_732, 71_421_811_355_805]
      end

      it "gets the expected results for wins at 21 points" do
        expect(subject.dirac_to_score(21)).to eq [444_356_092_776_315, 341_960_390_180_808]
      end
    end

    context "with vodik's input" do
      subject { AoC2021::DiracDice.new StringIO.new(<<~NUMBERS) }
        Player 1 starting position: 8
        Player 2 starting position: 1
      NUMBERS

      it "gets the expected results for wins at 1 point" do
        expect(subject.dirac_to_score(1)).to eq [27, 0]
      end

      it "gets the expected results for wins at 2 points" do
        expect(subject.dirac_to_score(2)).to eq [26, 27]
      end

      it "gets the expected results for wins at 3 points" do
        expect(subject.dirac_to_score(3)).to eq [23, 108]
      end

      it "gets the expected results for wins at 4 points" do
        expect(subject.dirac_to_score(4)).to eq [17, 270]
      end

      it "gets the expected results for wins at 5 points" do
        expect(subject.dirac_to_score(5)).to eq [448, 1009]
      end

      it "gets the expected results for wins at 6 points" do
        expect(subject.dirac_to_score(6)).to eq [13_548, 7669]
      end

      it "gets the expected results for wins at 7 points" do
        expect(subject.dirac_to_score(7)).to eq [115_461, 42_802]
      end

      it "gets the expected results for wins at 8 points" do
        expect(subject.dirac_to_score(8)).to eq [481_421, 214_834]
      end

      it "gets the expected results for wins at 9 points" do
        expect(subject.dirac_to_score(9)).to eq [1_237_307, 1_063_512]
      end

      it "gets the expected results for wins at 10 points" do
        expect(subject.dirac_to_score(10)).to eq [3_498_202, 4_381_099]
      end

      it "gets the expected results for wins at 11 point" do
        expect(subject.dirac_to_score(11)).to eq [14_263_794, 20_672_043]
      end

      it "gets the expected results for wins at 12 points" do
        expect(subject.dirac_to_score(12)).to eq [83_427_348, 108_902_869]
      end

      it "gets the expected results for wins at 13 points" do
        expect(subject.dirac_to_score(13)).to eq [559_035_775, 536_346_228]
      end

      it "gets the expected results for wins at 14 points" do
        expect(subject.dirac_to_score(14)).to eq [2_997_705_145, 2_453_492_582]
      end

      it "gets the expected results for wins at 15 points" do
        expect(subject.dirac_to_score(15)).to eq [12_973_782_795, 11_236_685_280]
      end

      it "gets the expected results for wins at 16 points" do
        expect(subject.dirac_to_score(16)).to eq [52_668_728_921, 50_451_713_310]
      end

      it "gets the expected results for wins at 17 points" do
        expect(subject.dirac_to_score(17)).to eq [227_421_283_105, 229_720_170_158]
      end

      it "gets the expected results for wins at 18 points" do
        expect(subject.dirac_to_score(18)).to eq [1_050_229_675_698, 1_106_264_797_891]
      end

      it "gets the expected results for wins at 19 points" do
        expect(subject.dirac_to_score(19)).to eq [5_050_819_482_983, 5_373_953_995_748]
      end

      it "gets the expected results for wins at 20 points" do
        expect(subject.dirac_to_score(20)).to eq [24_348_664_990_294, 25_311_443_930_831]
      end

      it "gets the expected results for wins at 21 points" do
        expect(subject.dirac_to_score(21)).to eq [113_467_910_521_040, 116_741_133_558_209]
      end
    end

    context "with my actual input" do
      subject { AoC2021::DiracDice.new StringIO.new(<<~NUMBERS) }
        Player 1 starting position: 9
        Player 2 starting position: 3
      NUMBERS

      it "gets the expected results for wins at 1 point" do
        expect(subject.dirac_to_score(1)).to eq [27, 0]
      end

      it "gets the expected results for wins at 2 points" do
        expect(subject.dirac_to_score(2)).to eq [27, 0]
      end

      it "gets the expected results for wins at 3 points" do
        expect(subject.dirac_to_score(3)).to eq [134, 23]
      end

      it "gets the expected results for wins at 4 points" do
        expect(subject.dirac_to_score(4)).to eq [478, 199]
      end

      it "gets the expected results for wins at 5 points" do
        expect(subject.dirac_to_score(5)).to eq [1327, 1300]
      end

      it "gets the expected results for wins at 6 points" do
        expect(subject.dirac_to_score(6)).to eq [6942, 5487]
      end

      it "gets the expected results for wins at 7 points" do
        expect(subject.dirac_to_score(7)).to eq [44_664, 15_657]
      end

      it "gets the expected results for wins at 8 points" do
        expect(subject.dirac_to_score(8)).to eq [263_453, 56_842]
      end

      it "gets the expected results for wins at 9 points" do
        expect(subject.dirac_to_score(9)).to eq [1_305_936, 311_993]
      end

      it "gets the expected results for wins at 10 points" do
        expect(subject.dirac_to_score(10)).to eq [5_666_175, 2_248_356]
      end

      it "gets the expected results for wins at 11 point" do
        expect(subject.dirac_to_score(11)).to eq [25_717_855, 17_012_236]
      end

      it "gets the expected results for wins at 12 points" do
        expect(subject.dirac_to_score(12)).to eq [130_653_171, 93_370_136]
      end

      it "gets the expected results for wins at 13 points" do
        expect(subject.dirac_to_score(13)).to eq [676_634_886, 412_321_607]
      end

      it "gets the expected results for wins at 14 points" do
        expect(subject.dirac_to_score(14)).to eq [3_218_069_724, 1_672_421_285]
      end

      it "gets the expected results for wins at 15 points" do
        expect(subject.dirac_to_score(15)).to eq [14_665_819_559, 7_078_438_276]
      end

      it "gets the expected results for wins at 16 points" do
        expect(subject.dirac_to_score(16)).to eq [66_652_310_663, 32_351_952_124]
      end

      it "gets the expected results for wins at 17 points" do
        expect(subject.dirac_to_score(17)).to eq [300_196_560_960, 160_116_009_889]
      end

      it "gets the expected results for wins at 18 points" do
        expect(subject.dirac_to_score(18)).to eq [1_394_336_687_349, 803_898_066_354]
      end

      it "gets the expected results for wins at 19 points" do
        expect(subject.dirac_to_score(19)).to eq [6_701_087_542_685, 3_902_175_769_490]
      end

      it "gets the expected results for wins at 20 points" do
        expect(subject.dirac_to_score(20)).to eq [31_950_745_840_868, 18_648_052_566_173]
      end

      it "gets the expected results for wins at 21 points" do
        expect(subject.dirac_to_score(21)).to eq [148_747_830_493_442, 89_305_072_914_203]
      end
    end
  end
end
