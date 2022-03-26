# frozen_string_literal: true

include AoC2021
include AoC2021::Amphipod

RSpec.describe Burrow do
  describe "::moves" do
    context "vodik starting state" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###A#C#B#A###
          #D#D#B#C#
          #########
      BOARD

      it "finds the expected moves from room 8" do
        expect(subject.moves(8)).to eq [:A, 8, [[1, 8], [0, 10], [9, 8], [10, 10]]]
      end

      it "finds the expected moves from room 6" do
        expect(subject.moves(6)).to eq [:B, 6, [[3, 40], [1, 80], [0, 100], [7, 40], [9, 80], [10, 100]]]
      end

      it "finds the expected moves from room 4" do
        expect(subject.moves(4)).to eq [:C, 4, [[3, 400], [1, 800], [0, 1000], [7, 400], [9, 800], [10, 1000]]]
      end

      it "finds the expected moves from room 2" do
        expect(subject.moves(2)).to eq [:A, 2, [[1, 2], [0, 4], [3, 2], [5, 8], [7, 12], [9, 14], [10, 16]]]
      end
    end

    context "vodik 2[1] -> 10" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #..........A#
        ###.#C#B#A###
          #D#D#B#C#
          #########
      BOARD

      it "finds the expected moves from room 8" do
        expect(subject.moves(8)).to eq [:A, 8, [[1, 8], [0, 10], [9, 8]]]
      end

      it "finds the expected moves from room 6" do
        expect(subject.moves(6)).to eq [:B, 6, [[3, 40], [1, 80], [0, 100], [7, 40], [9, 80]]]
      end

      it "finds the expected moves from room 4" do
        expect(subject.moves(4)).to eq [:C, 4, [[3, 400], [1, 800], [0, 1000], [7, 400], [9, 800]]]
      end

      it "finds the expected moves from room 2" do
        expect(subject.head_prune.moves(2)).to eq [:D, 2, [[1, 8000], [0, 10_000], [9, 8000]]]
      end
    end

    context "vodik 2[2] -> 9, 10 erased" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #.........D.#
        ###.#C#B#A###
          #.#D#B#C#
          #########
      BOARD

      it "finds the expected moves from room 8" do
        expect(subject.moves(8)).to eq [:A, 8, [[nil, 6]]]
      end

      it "finds the expected moves from room 6" do
        expect(subject.moves(6)).to eq [:B, 6, [[3, 40], [1, 80], [0, 100], [7, 40]]]
      end

      it "finds the expected moves from room 4" do
        expect(subject.moves(4)).to eq [:C, 4, [[3, 400], [1, 800], [0, 1000], [7, 400]]]
      end

      it "finds the expected moves from room 2" do
        expect(subject.head_prune.moves(2)).to be_nil
      end
    end

    context "vodik 4[1] -> 7" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #.......C.D.#
        ###.#.#B#A###
          #.#D#B#C#
          #########
      BOARD

      it "finds the expected moves from room 8" do
        expect(subject.moves(8)).to eq [:A, 8, []]
      end

      it "finds the expected moves from room 6" do
        expect(subject.moves(6)).to eq [:B, 6, [[3, 40], [1, 80], [0, 100]]]
      end

      it "finds the expected moves from room 4" do
        expect(subject.head_prune.moves(4)).to eq [:D, 4, [[3, 6000], [1, 10_000], [0, 12_000]]]
      end

      it "finds the expected moves from room 2" do
        expect(subject.head_prune.moves(2)).to be_nil
      end
    end

    context "vodik 8[1] -> 2[2]" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #.........D.#
        ###.#C#B#A###
          #.#D#B#C#
          #########
      BOARD

      it "finds the expected moves from room 8" do
        expect(subject.moves(8)).to eq [:A, 8, [[nil, 6]]]
      end
    end
  end

  describe "::has_path?" do
    it "finds clear paths" do
      # clear path between room 8 and room 2
      expect(Burrow.new([nil,
                         nil, [nil],
                         nil, %i[B],
                         nil, %i[C],
                         nil, %i[A],
                         nil, nil]).path?(2, 6)).to be true
      # clear path between room 8 and room 4
      expect(Burrow.new([nil,
                         nil, [nil],
                         nil, %i[B],
                         nil, %i[C],
                         nil, %i[A],
                         nil, nil]).path?(4, 4)).to be true
      # clear path between room 8 and room 6
      expect(Burrow.new([nil,
                         nil, [nil],
                         nil, %i[B],
                         nil, %i[C],
                         nil, %i[A],
                         nil, nil]).path?(6, 2)).to be true
      # clear path between room 2 and room 4
      expect(Burrow.new([nil,
                         nil, [nil],
                         nil, %i[B],
                         nil, %i[C],
                         nil, %i[A],
                         nil, nil]).path?(2, 2)).to be true
      # clear path between room 4 and room 6
      expect(Burrow.new([nil,
                         nil, [nil],
                         nil, %i[B],
                         nil, %i[C],
                         nil, %i[A],
                         nil, nil]).path?(4, 2)).to be true
      # clear path between room 6 and room 2
      expect(Burrow.new([nil,
                         nil, [nil],
                         nil, %i[B],
                         nil, %i[C],
                         nil, %i[A],
                         nil, nil]).path?(2, 4)).to be true
      # clear path between room 4 and room 6
      expect(Burrow.new([nil,
                         nil, [nil],
                         nil, %i[B],
                         nil, [nil],
                         :C, %i[A],
                         nil, nil]).path?(4, 2)).to be true
    end

    it "finds blocked paths" do
      expect(Burrow.new([nil,
                         nil, [nil],
                         nil, %i[B],
                         nil, [nil],
                         :C, %i[A],
                         nil, nil]).path?(6, 2)).to be false
      expect(Burrow.new([nil,
                         nil, [nil],
                         nil, %i[B],
                         nil, [nil],
                         :C, %i[A],
                         nil, nil]).path?(4, 4)).to be false
      expect(Burrow.new([nil,
                         nil, [nil],
                         nil, %i[B],
                         nil, [nil],
                         :C, %i[A],
                         nil, nil]).path?(2, 6)).to be false
    end
  end

  describe "#exit_energy" do
    context "with the example input" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###B#C#B#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds a cost of 3,122 energy for all non-homed pods to leave the initial rooms" do
        expect(subject.prune.exit_energy).to eq 3_122
      end
    end
  end

  describe "#entry_energy" do
    context "with the example input" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###B#C#B#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds a cost of 3,131 energy to fill all rooms from the initial state" do
        expect(subject.prune.entry_energy).to eq 3_131
      end
    end
  end

  context "with the unfolded example input" do
    subject { Burrow.new(StringIO.new(<<~BOARD)) }
      #############
      #...........#
      ###B#C#B#D###
        #D#C#B#A#
        #D#B#A#C#
        #A#D#C#A#
        #########
    BOARD

    it "finds a cost of x to leave the rooms" do
      expect(subject.prune.exit_energy)
        .to eq 10 + 2000 + 3000 + 100 + 200 + 30 + 4000 + 10 + 20 + 3 + 1000 + 2 + 300 + 4
    end

    it "finds a least score of 44169 energy" do
      # expect(subject.play_game(PriorityQueue.new)).to eq 44_169
    end
  end

  describe "#play_vodik" do
    context "with the example input" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###B#C#B#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds a least score of 12521 energy" do
        expect(subject.play_vodik(PriorityQueue.new)).to eq 12_521
      end
    end

    context "with my actual input" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###A#D#A#B###
          #B#C#D#C#
          #########
      BOARD

      it "finds a least score of 13455 energy" do
        expect(subject.play_vodik(PriorityQueue.new)).to eq 13_455
      end
    end

    context "with vodik's input" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###A#C#B#A###
          #D#D#B#C#
          #########
      BOARD

      it "finds a least score of 18,195 energy" do
        expect(subject.play_vodik(PriorityQueue.new)).to eq 18_195
      end
    end

    context "with the unfolded example input" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###B#C#B#D###
          #D#C#B#A#
          #D#B#A#C#
          #A#D#C#A#
          #########
      BOARD

      it "finds a cost of 10,679 to leave the rooms" do
        expect(subject.prune.exit_energy)
          .to eq 10 + 2000 + 3000 + 100 + 200 + 30 + 4000 + 10 + 20 + 3 + 1000 + 2 + 300 + 4
      end

      it "finds a least score of 44169 energy" do
        expect(subject.play_vodik(PriorityQueue.new)).to eq 44_169
      end
    end

    context "with my actual unfolded input" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###A#D#A#B###
          #D#C#B#A#
          #D#B#A#C#
          #B#C#D#C#
          #########
      BOARD

      it "finds a least score of 43567 energy" do
        expect(subject.play_vodik(PriorityQueue.new)).to eq 43_567
      end
    end

    context "with vodik's part 2 input" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###A#C#B#A###
          #D#C#B#A#
          #D#B#A#C#
          #D#D#B#C#
          #########
      BOARD

      it "finds a least score of 50,265 energy" do
        expect(subject.play_vodik(PriorityQueue.new)).to eq 50_265
      end
    end
  end

  describe "Burrow#commit" do
    context "with vodik's part 2 input" do
      subject { Burrow.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###A#C#B#A###
          #D#C#B#A#
          #D#B#A#C#
          #D#D#B#C#
          #########
      BOARD

      it "commits a pod from the last room" do
        expect(subject.commit(8, 10).board)
          .to eq Burrow.new(StringIO.new(<<~BOARD)).head_prune.board
            #############
            #..........A#
            ###A#C#B#.###
              #D#C#B#A#
              #D#B#A#C#
              #D#D#B#C#
              #########
        BOARD
      end
    end
  end
end

RSpec.describe Move do
  describe "::next_moves" do
    it "finds the expected next moves from the hall" do
      expect(Move.new([:D,
                       nil, %i[A A A A],
                       nil, %i[B B B B],
                       nil, %i[C C C C],
                       nil, [nil, :D, :D, :D],
                       nil, nil]).next_moves)
        .to eq Set[
                 Move.new([nil,
                           nil, %i[A A A A],
                           nil, %i[B B B B],
                           nil, %i[C C C C],
                           nil, %i[D D D D],
                           nil, nil], 9000)
               ]
      expect(Move.new([nil,
                       nil, %i[A A A A],
                       nil, %i[B B B B],
                       nil, %i[C C C C],
                       nil, [nil, :D, :D, :D],
                       nil, :D]).next_moves)
        .to eq Set[
                 Move.new([nil,
                           nil, %i[A A A A],
                           nil, %i[B B B B],
                           nil, %i[C C C C],
                           nil, %i[D D D D],
                           nil, nil], 3000)
               ]
    end

    it "finds one expected next move" do
      expect(Move.new([:x,
                       :x, %i[A A A A],
                       :x, %i[B B B B],
                       :x, %i[D C C C],
                       :x, %i[A D D D],
                       nil, :x]).next_moves)
        .to eq Set[
                 Move.new([:x,
                           :x, %i[A A A A],
                           :x, %i[B B B B],
                           :x, %i[D C C C],
                           :x, [nil] + %i[D D D],
                           :A, :x], 2)
               ]
    end

    it "finds all expected next moves into a hallway spot" do
      expect(Move.new([nil,
                       nil, %i[B D D A],
                       nil, %i[C C B D],
                       nil, %i[B B A C],
                       nil, %i[D A C A],
                       nil, nil]).next_moves)
        .to eq Set[
                 Move.new([:B,
                           nil, [nil] + %i[D D A],
                           nil, %i[C C B D],
                           nil, %i[B B A C],
                           nil, %i[D A C A],
                           nil, nil], 30),
                 Move.new([nil,
                           :B, [nil] + %i[D D A],
                           nil, %i[C C B D],
                           nil, %i[B B A C],
                           nil, %i[D A C A],
                           nil, nil], 20),
                 Move.new([nil,
                           nil, [nil] + %i[D D A],
                           :B, %i[C C B D],
                           nil, %i[B B A C],
                           nil, %i[D A C A],
                           nil, nil], 20),
                 Move.new([nil,
                           nil, [nil] + %i[D D A],
                           nil, %i[C C B D],
                           :B, %i[B B A C],
                           nil, %i[D A C A],
                           nil, nil], 40),
                 Move.new([nil,
                           nil, [nil] + %i[D D A],
                           nil, %i[C C B D],
                           nil, %i[B B A C],
                           :B, %i[D A C A],
                           nil, nil], 60),
                 Move.new([nil,
                           nil, [nil] + %i[D D A],
                           nil, %i[C C B D],
                           nil, %i[B B A C],
                           nil, %i[D A C A],
                           :B, nil], 80),
                 Move.new([nil,
                           nil, [nil] + %i[D D A],
                           nil, %i[C C B D],
                           nil, %i[B B A C],
                           nil, %i[D A C A],
                           nil, :B], 90),
                 Move.new([:C,
                           nil, %i[B D D A],
                           nil, [nil] + %i[C B D],
                           nil, %i[B B A C],
                           nil, %i[D A C A],
                           nil, nil], 500),
                 Move.new([nil,
                           :C, %i[B D D A],
                           nil, [nil] + %i[C B D],
                           nil, %i[B B A C],
                           nil, %i[D A C A],
                           nil, nil], 400),
                 Move.new([nil,
                           nil, %i[B D D A],
                           :C, [nil] + %i[C B D],
                           nil, %i[B B A C],
                           nil, %i[D A C A],
                           nil, nil], 200),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, [nil] + %i[C B D],
                           :C, %i[B B A C],
                           nil, %i[D A C A],
                           nil, nil], 200),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, [nil] + %i[C B D],
                           nil, %i[B B A C],
                           :C, %i[D A C A],
                           nil, nil], 400),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, [nil] + %i[C B D],
                           nil, %i[B B A C],
                           nil, %i[D A C A],
                           :C, nil], 600),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, [nil] + %i[C B D],
                           nil, %i[B B A C],
                           nil, %i[D A C A],
                           nil, :C], 700),
                 Move.new([:B,
                           nil, %i[B D D A],
                           nil, %i[C C B D],
                           nil, [nil] + %i[B A C],
                           nil, %i[D A C A],
                           nil, nil], 70),
                 Move.new([nil,
                           :B, %i[B D D A],
                           nil, %i[C C B D],
                           nil, [nil] + %i[B A C],
                           nil, %i[D A C A],
                           nil, nil], 60),
                 Move.new([nil,
                           nil, %i[B D D A],
                           :B, %i[C C B D],
                           nil, [nil] + %i[B A C],
                           nil, %i[D A C A],
                           nil, nil], 40),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, %i[C C B D],
                           :B, [nil] + %i[B A C],
                           nil, %i[D A C A],
                           nil, nil], 20),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, %i[C C B D],
                           nil, [nil] + %i[B A C],
                           :B, %i[D A C A],
                           nil, nil], 20),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, %i[C C B D],
                           nil, [nil] + %i[B A C],
                           nil, %i[D A C A],
                           :B, nil], 40),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, %i[C C B D],
                           nil, [nil] + %i[B A C],
                           nil, %i[D A C A],
                           nil, :B], 50),
                 Move.new([:D,
                           nil, %i[B D D A],
                           nil, %i[C C B D],
                           nil, %i[B B A C],
                           nil, [nil] + %i[A C A],
                           nil, nil], 9000),
                 Move.new([nil,
                           :D, %i[B D D A],
                           nil, %i[C C B D],
                           nil, %i[B B A C],
                           nil, [nil] + %i[A C A],
                           nil, nil], 8000),
                 Move.new([nil,
                           nil, %i[B D D A],
                           :D, %i[C C B D],
                           nil, %i[B B A C],
                           nil, [nil] + %i[A C A],
                           nil, nil], 6000),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, %i[C C B D],
                           :D, %i[B B A C],
                           nil, [nil] + %i[A C A],
                           nil, nil], 4000),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, %i[C C B D],
                           nil, %i[B B A C],
                           :D, [nil] + %i[A C A],
                           nil, nil], 2000),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, %i[C C B D],
                           nil, %i[B B A C],
                           nil, [nil] + %i[A C A],
                           :D, nil], 2000),
                 Move.new([nil,
                           nil, %i[B D D A],
                           nil, %i[C C B D],
                           nil, %i[B B A C],
                           nil, [nil] + %i[A C A],
                           nil, :D], 3000)
               ]
    end

    it "finds all expected next moves into a hall or room" do
      expect(Move.new([:x,
                       :x, [nil] + %i[A A A],
                       nil, [nil],
                       nil, [nil],
                       nil, %i[A D D D],
                       :x, :x]).next_moves)
        .to eq Set[
                 Move.new([:x,
                           :x, [nil] + %i[A A A],
                           :A, [nil],
                           nil, [nil],
                           nil, [nil] + %i[D D D],
                           :x, :x], 6),
                 Move.new([:x,
                           :x, [nil] + %i[A A A],
                           nil, [nil],
                           :A, [nil],
                           nil, [nil] + %i[D D D],
                           :x, :x], 4),
                 Move.new([:x,
                           :x, [nil] + %i[A A A],
                           nil, [nil],
                           nil, [nil],
                           :A, [nil] + %i[D D D],
                           :x, :x], 2),
                 Move.new([:x,
                           :x, %i[A A A A],
                           nil, [nil],
                           nil, [nil],
                           nil, [nil] + %i[D D D],
                           :x, :x], 8)
               ]
    end

    it "finds exactly the expected moves from this board" do
      expect(Move.new([:A,
                       :B,
                       [nil] + [nil],
                       :D,
                       [nil] + [nil],
                       :C,
                       [nil] + [nil],
                       :D,
                       %i[B C],
                       :A,
                       nil]).next_moves)
        .to eq Set[
                 Move.new([:A,
                           :B,
                           [nil] + [nil],
                           :D,
                           [nil] + [nil],
                           nil,
                           [nil] + %i[C],
                           :D,
                           %i[B C],
                           :A,
                           nil], 300)
               ]
    end

    context "from the initial configuration" do
      subject { Move.new(StringIO.new(<<~BOARD)).next_moves }
        #############
        #...........#
        ###B#C#B#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds [6, 0] -> 3 among the possible next moves" do
        expect(subject).to include Move.new(StringIO.new(<<~BOARD), 40)
          #############
          #...B.......#
          ###B#C#.#D###
            #A#D#C#A#
            #########
        BOARD
      end
    end

    context "from the second configuration" do
      subject { Move.new(StringIO.new(<<~BOARD)).next_moves }
        #############
        #...B.......#
        ###B#C#.#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds [4, 0] -> [6, 0] among the possible next moves" do
        expect(subject).to include Move.new(StringIO.new(<<~BOARD), 400)
          #############
          #...B.......#
          ###B#.#C#D###
            #A#D#C#A#
            #########
        BOARD
      end
    end

    context "from the third configuration" do
      subject { Move.new(StringIO.new(<<~BOARD)).next_moves }
        #############
        #...B.......#
        ###B#.#C#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds [4, 1] -> 5 among the possible next moves" do
        expect(subject).to include Move.new(StringIO.new(<<~BOARD), 3000)
          #############
          #...B.D.....#
          ###B#.#C#D###
            #A#.#C#A#
            #########
        BOARD
      end
    end

    context "from the third-A configuration" do
      subject { Move.new(StringIO.new(<<~BOARD)).next_moves }
        #############
        #...B.D.....#
        ###B#.#C#D###
          #A#.#C#A#
          #########
      BOARD

      it "finds 3 -> [4, 1] among the possible next moves" do
        expect(subject).to include Move.new(StringIO.new(<<~BOARD), 30)
          #############
          #.....D.....#
          ###B#.#C#D###
            #A#B#C#A#
            #########
        BOARD
      end
    end

    context "from the fourth configuration" do
      subject { Move.new(StringIO.new(<<~BOARD)).next_moves }
        #############
        #.....D.....#
        ###B#.#C#D###
          #A#B#C#A#
          #########
      BOARD

      it "finds [2, 0] -> [4, 0] among the possible next moves" do
        expect(subject).to include Move.new(StringIO.new(<<~BOARD), 40)
          #############
          #.....D.....#
          ###.#B#C#D###
            #A#B#C#A#
            #########
        BOARD
      end
    end

    context "from the fifth configuration" do
      subject { Move.new(StringIO.new(<<~BOARD)).next_moves }
        #############
        #.....D.....#
        ###.#B#C#D###
          #A#B#C#A#
          #########
      BOARD

      it "finds [8, 0] -> 7 among the possible next moves" do
        expect(subject).to include Move.new(StringIO.new(<<~BOARD), 2000)
          #############
          #.....D.D...#
          ###.#B#C#.###
            #A#B#C#A#
            #########
        BOARD
      end
    end

    context "from the fifth-A configuration" do
      subject { Move.new(StringIO.new(<<~BOARD)).next_moves }
        #############
        #.....D.D...#
        ###.#B#C#.###
          #A#B#C#A#
          #########
      BOARD

      it "finds [8, 1] -> 9 among the possible next moves" do
        expect(subject).to include Move.new(StringIO.new(<<~BOARD), 3)
          #############
          #.....D.D.A.#
          ###.#B#C#.###
            #A#B#C#.#
            #########
        BOARD
      end
    end

    context "from the sixth configuration" do
      subject { Move.new(StringIO.new(<<~BOARD)).next_moves }
        #############
        #.....D.D.A.#
        ###.#B#C#.###
          #A#B#C#.#
          #########
      BOARD

      it "finds [8, 1] -> 9 among the possible next moves" do
        expect(subject).to include Move.new(StringIO.new(<<~BOARD), 3000)
          #############
          #.....D...A.#
          ###.#B#C#.###
            #A#B#C#D#
            #########
        BOARD
      end
    end

    context "from the sixth-A configuration" do
      subject { Move.new(StringIO.new(<<~BOARD)).next_moves }
        #############
        #.....D...A.#
        ###.#B#C#.###
          #A#B#C#D#
          #########
      BOARD

      it "finds [8, 1] -> 9 among the possible next moves" do
        expect(subject).to include Move.new(StringIO.new(<<~BOARD), 4000)
          #############
          #.........A.#
          ###.#B#C#D###
            #A#B#C#D#
            #########
        BOARD
      end
    end

    context "from the seventh configuration" do
      subject { Move.new(StringIO.new(<<~BOARD)).next_moves }
        #############
        #.........A.#
        ###.#B#C#D###
          #A#B#C#D#
          #########
      BOARD

      it "finds [8, 1] -> 9 among the possible next moves" do
        expect(subject).to include Move.new(StringIO.new(<<~BOARD), 8)
          #############
          #...........#
          ###A#B#C#D###
            #A#B#C#D#
            #########
        BOARD
      end
    end

    context "from this configuration" do
      subject { Move.new(StringIO.new(<<~BOARD)).next_moves }
        #############
        #...........#
        ###B#C#B#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds [8, 1] -> 9 among the possible next moves" do
        expect(subject)
          .to include Move.new(StringIO.new(<<~BOARD), 20)
            #############
            #.B.........#
            ###.#C#B#D###
              #A#D#C#A#
              #########
        BOARD
      end
    end
  end

  describe "::clear_path_to?" do
    it "finds clear paths" do
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, %i[C],
                       nil, %i[A],
                       nil, nil]).clear_path_to?(0, 8)).to be true
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, %i[C],
                       nil, %i[A],
                       nil, nil]).clear_path_to?(1, 8)).to be true
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, %i[C],
                       nil, %i[A],
                       nil, nil]).clear_path_to?(3, 8)).to be true
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, %i[C],
                       nil, %i[A],
                       nil, nil]).clear_path_to?(5, 8)).to be true
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, %i[C],
                       nil, %i[A],
                       nil, nil]).clear_path_to?(7, 8)).to be true
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, %i[C],
                       nil, %i[A],
                       nil, nil]).clear_path_to?(9, 8)).to be true
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, [nil],
                       :C, %i[A],
                       nil, nil]).clear_path_to?(10, 8)).to be true
    end

    it "finds blocked paths" do
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, [nil],
                       :C, %i[A],
                       nil, nil]).clear_path_to?(7, 8)).to be false
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, [nil],
                       :C, %i[A],
                       nil, nil]).clear_path_to?(5, 8)).to be false
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, [nil],
                       :C, %i[A],
                       nil, nil]).clear_path_to?(3, 8)).to be false
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, [nil],
                       :C, %i[A],
                       nil, nil]).clear_path_to?(1, 8)).to be false
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, [nil],
                       :C, %i[A],
                       nil, nil]).clear_path_to?(0, 8)).to be false
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, [nil],
                       nil, %i[A],
                       :C, nil]).clear_path_to?(9, 8)).to be false
      expect(Move.new([nil,
                       nil, [nil],
                       nil, %i[B],
                       nil, [nil],
                       nil, %i[A],
                       :C, nil]).clear_path_to?(10, 8)).to be false
    end
  end

  describe "::ready_to_move" do
    it "lists the pieces that are able to move" do
      expect(Move.new([nil,
                       nil, %i[B D D A],
                       nil, %i[C C B D],
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).ready_to_move).to eq [[2, 0], [4, 0], [6, 0], [8, 1]]
      expect(Move.new([nil,
                       :B, [nil] + %i[D D A],
                       nil, %i[C C B D],
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).ready_to_move).to eq [[2, 1], [4, 0], [6, 0], [8, 1]]
      expect(Move.new([nil,
                       :A, [nil] + [nil, nil, :A],
                       nil, %i[C C B D],
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).ready_to_move).to eq [1, [4, 0], [6, 0], [8, 1]]
    end
  end

  describe "::can_move" do
    it "correctly indicates that a piece can move from a room" do
      expect(Move.new([nil,
                       nil, %i[B D D A], # x = 2
                       nil, %i[C C B D], # x = 4
                       nil, %i[B B A C], # x = 6
                       nil, [nil] + %i[A C A], # x = 8
                       nil, :D]).can_move_from_room_spot?(2, 0)).to be true
      expect(Move.new([nil,
                       :B, [nil] + %i[D D A],
                       nil, %i[C C B D],
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).can_move_from_room_spot?(2, 1)).to be true
      expect(Move.new([nil,
                       nil, %i[B D D A],
                       nil, [nil] + [nil] + %i[C B], # [4, 2] is in the wrong room (:C should be in [6, y])
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).can_move_from_room_spot?(4, 2)).to be true
      expect(Move.new([nil,
                       nil, %i[B D D A],
                       nil, [nil] + [nil] + %i[B C], # [4, 3] is in the wrong room, so [4, 2] can move
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).can_move_from_room_spot?(4, 2)).to be true
    end

    it "correctly indicates that a piece cannot move from a room" do
      expect(Move.new([nil,
                       nil, %i[B D D A],
                       nil, %i[C C B D],
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).can_move_from_room_spot?(2, 2)).to be false # [2, 2] is not nearest the door
      expect(Move.new([nil,
                       :C, %i[B D D A],
                       :C, [nil] + [nil] + %i[B D],
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).can_move_from_room_spot?(2, 0)).to be false # adjoining hallways spaces both full
      expect(Move.new([nil,
                       nil, %i[B D D A],
                       nil, [nil] + [nil] + %i[B B], # in the right room and no other kind below [2, 2]
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).can_move_from_room_spot?(4, 2)).to be false
      expect(Move.new([nil,
                       nil, [nil] + %i[A], # right room, farthest from door
                       nil, [nil] + [nil] + %i[B B],
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).can_move_from_room_spot?(2, 1)).to be false
    end

    it "correctly indicates that a piece can move from the hallway" do
      expect(Move.new([:B, # In the hall with a clear path to room x=4 and only B already in that room
                       nil, %i[B D D A],
                       nil, [nil] + [nil] + %i[B B],
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).can_move_to_room?(0)).to be true
    end

    it "correctly indicates that a piece cannot move from the hallway" do
      expect(Move.new([:B, # Path blocked at x=1
                       :B, %i[B D D A],
                       nil, [nil] + [nil] + %i[B B],
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).can_move_to_room?(0)).to be false
      expect(Move.new([:B,
                       :B, %i[B D D A], # Path open but :C in :B's room
                       nil, [nil] + [nil] + %i[B C],
                       nil, %i[B B A C],
                       nil, [nil] + %i[A C A],
                       nil, :D]).can_move_to_room?(1)).to be false
    end
  end

  describe "final_state" do
    it "detects a final state" do
      expect(Move.new([nil, nil,
                       %i[A A A A], nil,
                       %i[B B B B], nil,
                       %i[C C C C], nil,
                       %i[D D D D], nil, nil]).final_state?).to be true
      expect(Move.new([nil, nil,
                       %i[A], nil,
                       %i[B], nil,
                       %i[C], nil,
                       %i[D], nil, nil]).final_state?).to be true
    end

    it "detects a non-final state" do
      expect(Move.new([nil, nil,
                       %i[A A A B], nil,
                       %i[B B B A], nil,
                       %i[C C C C], nil,
                       %i[D D D D], nil, nil]).final_state?).to be false
      expect(Move.new([nil, nil,
                       %i[A A A] + [nil], nil,
                       %i[B B B A], nil,
                       %i[C C C C], nil,
                       %i[D D D D], nil, :A]).final_state?).to be false
      expect(Move.new([nil, nil,
                       %i[A], nil,
                       %i[B], nil,
                       %i[D], nil,
                       %i[C], nil, nil]).final_state?).to be false
      expect(Move.new([nil, nil,
                       %i[A], nil,
                       [nil], :B,
                       %i[D], nil,
                       %i[C], nil, nil]).final_state?).to be false
    end
  end

  describe "#play_game" do
    context "with the example input" do
      subject { Move.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###B#C#B#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds a least score of 12521 energy" do
        # expect(subject.play_game(PriorityQueue.new)).to eq 12_521
      end
    end

    context "with my actual input" do
      subject { Move.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###A#D#A#B###
          #B#C#D#C#
          #########
      BOARD

      it "finds a least score of 13455 energy" do
        # expect(subject.play_game(PriorityQueue.new)).to eq 13_455
      end
    end

    context "with vodik's input" do
      subject { Move.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###A#C#B#A###
          #D#D#B#C#
          #########
      BOARD

      it "finds a least score of 18,195 energy" do
        # expect(subject.play_game(PriorityQueue.new)).to eq 18_195
      end
    end

    context "with my actual unfolded input" do
      subject { Move.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###A#D#A#B###
          #D#C#B#A#
          #D#B#A#C#
          #B#C#D#C#
          #########
      BOARD

      it "finds a least score of 43567 energy" do
        # expect(subject.play_game(PriorityQueue.new)).to eq 43_567
      end
    end

    context "with vodik's part 2 input" do
      subject { Move.new(StringIO.new(<<~BOARD)) }
        #############
        #...........#
        ###A#C#B#A###
          #D#C#B#A#
          #D#B#A#C#
          #D#D#B#C#
          #########
      BOARD

      it "finds a least score of 50,265 energy" do
        # expect(subject.play_game(PriorityQueue.new)).to eq 50_265
      end
    end
  end

  describe "Room#empty?" do
    it "finds non-empty rooms" do
      expect(Room.new(%i[A B]).empty?).to be false
    end

    it "finds empty rooms" do
      expect(Room.new([]).empty?).to be true
    end
  end

  describe "Room#take" do
    it "takes the top pod from the room" do
      room = Room.new(%i[A B])
      pod  = room.take
      expect(pod).to eq :A
      expect(room.room).to eq [:B]
    end

    it "takes the top pod from the room with 1 pod" do
      room = Room.new([:B])
      pod  = room.take
      expect(pod).to eq :B
      expect(room.room).to eq []
    end

    it "takes nil from an empty room" do
      room = Room.new([])
      pod  = room.take
      expect(pod).to eq nil
      expect(room.room).to eq []
    end
  end
end
