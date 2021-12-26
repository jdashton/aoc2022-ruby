# frozen_string_literal: true

require "rspec"

require "aoc2021/puzzles/sea_cucumber"

RSpec.describe AoC2021::SeaCucumber do
  context "with a single row" do
    describe "#east_row" do
      subject { AoC2021::SeaCucumber.new StringIO.new "...>>>>>..." }

      it "finds the expected board after 1 step" do
        subject.east_row(0)
        expect(subject.next[0]).to eq "...>>>>.>..".chars
      end

      it "finds the expected board after 2 steps" do
        subject.east_row(0)
        subject.finalize
        subject.east_row(0)
        expect(subject.next[0]).to eq "...>>>.>.>.".chars
      end

      it "finds the expected board after 3 steps" do
        subject.east_row(0)
        subject.finalize
        subject.east_row(0)
        subject.finalize
        subject.east_row(0)
        expect(subject.next[0]).to eq "...>>.>.>.>".chars
      end

      it "finds the expected board after 4 steps" do
        subject.east_row(0)
        subject.finalize
        subject.east_row(0)
        subject.finalize
        subject.east_row(0)
        subject.finalize
        subject.east_row(0)
        expect(subject.next[0]).to eq ">..>.>.>.>.".chars
      end

      it "finds the expected board after 5 steps" do
        subject.east_row(0)
        subject.finalize
        subject.east_row(0)
        subject.finalize
        subject.east_row(0)
        subject.finalize
        subject.east_row(0)
        subject.finalize
        subject.east_row(0)
        expect(subject.next[0]).to eq ".>..>.>.>.>".chars
      end
    end
  end

  context "with east and south together" do
    describe "#after_steps" do
      subject { AoC2021::SeaCucumber.new StringIO.new(<<~CUCUMBERS) }
        ..........
        .>v....v..
        .......>..
        ..........
      CUCUMBERS

      it "finds the expected board after 1 step" do
        expect(subject.after_steps(1))
          .to eq <<~CUCUMBERS
            ..........
            .>........
            ..v....v>.
            ..........
        CUCUMBERS
      end
    end
  end

  context "with edge wrapping" do
    describe "#after_steps" do
      subject { AoC2021::SeaCucumber.new StringIO.new(<<~CUCUMBERS) }
        ...>...
        .......
        ......>
        v.....>
        ......>
        .......
        ..vvv..
      CUCUMBERS

      it "finds the expected board after 1 step" do
        expect(subject.after_steps(1))
          .to eq <<~CUCUMBERS
            ..vv>..
            .......
            >......
            v.....>
            >......
            .......
            ....v..
        CUCUMBERS
      end

      it "finds the expected board after 2 steps" do
        expect(subject.after_steps(2))
          .to eq <<~CUCUMBERS
            ....v>.
            ..vv...
            .>.....
            ......>
            v>.....
            .......
            .......
        CUCUMBERS
      end

      it "finds the expected board after 3 steps" do
        expect(subject.after_steps(3))
          .to eq <<~CUCUMBERS
            ......>
            ..v.v..
            ..>v...
            >......
            ..>....
            v......
            .......
        CUCUMBERS
      end

      it "finds the expected board after 4 steps" do
        expect(subject.after_steps(4))
          .to eq <<~CUCUMBERS
            >......
            ..v....
            ..>.v..
            .>.v...
            ...>...
            .......
            v......
        CUCUMBERS
      end
    end
  end

  context "with last sample" do
    subject { AoC2021::SeaCucumber.new StringIO.new(<<~CUCUMBERS) }
      v...>>.vv>
      .vv>>.vv..
      >>.>v>...v
      >>v>>.>.v.
      v>v.vv.v..
      >.>>..v...
      .vv..>.>v.
      v.v..>>v.v
      ....v..v.>
    CUCUMBERS

    describe "#moves_to_final" do
      it "finds a stable configuration after 58 moves" do
        expect(subject.moves_to_final).to eq 58
      end
    end

    describe "#after_steps" do
      it "finds the expected board after 1 step" do
        expect(subject.after_steps(1))
          .to eq <<~CUCUMBERS
            ....>.>v.>
            v.v>.>v.v.
            >v>>..>v..
            >>v>v>.>.v
            .>v.v...v.
            v>>.>vvv..
            ..v...>>..
            vv...>>vv.
            >.v.v..v.v
        CUCUMBERS
      end

      it "finds the expected board after 2 steps" do
        expect(subject.after_steps(2))
          .to eq <<~CUCUMBERS
            >.v.v>>..v
            v.v.>>vv..
            >v>.>.>.v.
            >>v>v.>v>.
            .>..v....v
            .>v>>.v.v.
            v....v>v>.
            .vv..>>v..
            v>.....vv.
        CUCUMBERS
      end

      it "finds the expected board after 3 steps" do
        expect(subject.after_steps(3))
          .to eq <<~CUCUMBERS
            v>v.v>.>v.
            v...>>.v.v
            >vv>.>v>..
            >>v>v.>.v>
            ..>....v..
            .>.>v>v..v
            ..v..v>vv>
            v.v..>>v..
            .v>....v..
        CUCUMBERS
      end

      it "finds the expected board after 4 steps" do
        expect(subject.after_steps(4))
          .to eq <<~CUCUMBERS
            v>..v.>>..
            v.v.>.>.v.
            >vv.>>.v>v
            >>.>..v>.>
            ..v>v...v.
            ..>>.>vv..
            >.v.vv>v.v
            .....>>vv.
            vvv>...v..
        CUCUMBERS
      end

      it "finds the expected board after 5 steps" do
        expect(subject.after_steps(5))
          .to eq <<~CUCUMBERS
            vv>...>v>.
            v.v.v>.>v.
            >.v.>.>.>v
            >v>.>..v>>
            ..v>v.v...
            ..>.>>vvv.
            .>...v>v..
            ..v.v>>v.v
            v.v.>...v.
        CUCUMBERS
      end

      it "finds the expected board after 10 steps" do
        expect(subject.after_steps(10))
          .to eq <<~CUCUMBERS
            ..>..>>vv.
            v.....>>.v
            ..v.v>>>v>
            v>.>v.>>>.
            ..v>v.vv.v
            .v.>>>.v..
            v.v..>v>..
            ..v...>v.>
            .vv..v>vv.
        CUCUMBERS
      end

      it "finds the expected board after 20 steps" do
        expect(subject.after_steps(20))
          .to eq <<~CUCUMBERS
            v>.....>>.
            >vv>.....v
            .>v>v.vv>>
            v>>>v.>v.>
            ....vv>v..
            .v.>>>vvv.
            ..v..>>vv.
            v.v...>>.v
            ..v.....v>
        CUCUMBERS
      end

      it "finds the expected board after 30 steps" do
        expect(subject.after_steps(30))
          .to eq <<~CUCUMBERS
            .vv.v..>>>
            v>...v...>
            >.v>.>vv.>
            >v>.>.>v.>
            .>..v.vv..
            ..v>..>>v.
            ....v>..>v
            v.v...>vv>
            v.v...>vvv
        CUCUMBERS
      end

      it "finds the expected board after 40 steps" do
        expect(subject.after_steps(40))
          .to eq <<~CUCUMBERS
            >>v>v..v..
            ..>>v..vv.
            ..>>>v.>.v
            ..>>>>vvv>
            v.....>...
            v.v...>v>>
            >vv.....v>
            .>v...v.>v
            vvv.v..v.>
        CUCUMBERS
      end

      it "finds the expected board after 50 steps" do
        expect(subject.after_steps(50))
          .to eq <<~CUCUMBERS
            ..>>v>vv.v
            ..v.>>vv..
            v.>>v>>v..
            ..>>>>>vv.
            vvv....>vv
            ..v....>>>
            v>.......>
            .vv>....v>
            .>v.vv.v..
        CUCUMBERS
      end

      it "finds the expected board after 55 steps" do
        expect(subject.after_steps(55))
          .to eq <<~CUCUMBERS
            ..>>v>vv..
            ..v.>>vv..
            ..>>v>>vv.
            ..>>>>>vv.
            v......>vv
            v>v....>>v
            vvv...>..>
            >vv.....>.
            .>v.vv.v..
        CUCUMBERS
      end

      it "finds the expected board after 56 steps" do
        expect(subject.after_steps(56))
          .to eq <<~CUCUMBERS
            ..>>v>vv..
            ..v.>>vv..
            ..>>v>>vv.
            ..>>>>>vv.
            v......>vv
            v>v....>>v
            vvv....>.>
            >vv......>
            .>v.vv.v..
        CUCUMBERS
      end

      it "finds the expected board after 57 steps" do
        expect(subject.after_steps(57))
          .to eq <<~CUCUMBERS
            ..>>v>vv..
            ..v.>>vv..
            ..>>v>>vv.
            ..>>>>>vv.
            v......>vv
            v>v....>>v
            vvv.....>>
            >vv......>
            .>v.vv.v..
        CUCUMBERS
      end

      it "finds the expected board after 58 steps" do
        expect(subject.after_steps(58))
          .to eq <<~CUCUMBERS
            ..>>v>vv..
            ..v.>>vv..
            ..>>v>>vv.
            ..>>>>>vv.
            v......>vv
            v>v....>>v
            vvv.....>>
            >vv......>
            .>v.vv.v..
        CUCUMBERS
      end
    end
  end
end
