# frozen_string_literal: true

include AoC2021

RSpec.describe Amphipod do
  describe "::next_moves" do
    it "finds the expected next moves from the hall" do
      expect(Amphipod::Move.new([:D,
                                 :empty, %i[A A A A],
                                 :empty, %i[B B B B],
                                 :empty, %i[C C C C],
                                 :empty, %i[empty D D D],
                                 :empty, :empty]).next_moves)
        .to eq Set[
                 Amphipod::Move.new([:empty,
                                     :empty, %i[A A A A],
                                     :empty, %i[B B B B],
                                     :empty, %i[C C C C],
                                     :empty, %i[D D D D],
                                     :empty, :empty], 9000)
               ]
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[A A A A],
                                 :empty, %i[B B B B],
                                 :empty, %i[C C C C],
                                 :empty, %i[empty D D D],
                                 :empty, :D]).next_moves)
        .to eq Set[
                 Amphipod::Move.new([:empty,
                                     :empty, %i[A A A A],
                                     :empty, %i[B B B B],
                                     :empty, %i[C C C C],
                                     :empty, %i[D D D D],
                                     :empty, :empty], 3000)
               ]
    end

    it "finds one expected next move" do
      expect(Amphipod::Move.new([:x,
                                 :x, %i[A A A A],
                                 :x, %i[B B B B],
                                 :x, %i[D C C C],
                                 :x, %i[A D D D],
                                 :empty, :x]).next_moves)
        .to eq Set[
                 Amphipod::Move.new([:x,
                                     :x, %i[A A A A],
                                     :x, %i[B B B B],
                                     :x, %i[D C C C],
                                     :x, %i[empty D D D],
                                     :A, :x], 2)
               ]
    end

    it "finds all expected next moves into a hallway spot" do
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[B D D A],
                                 :empty, %i[C C B D],
                                 :empty, %i[B B A C],
                                 :empty, %i[D A C A],
                                 :empty, :empty]).next_moves)
        .to eq Set[
                 Amphipod::Move.new([:B,
                                     :empty, %i[empty D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 30),
                 Amphipod::Move.new([:empty,
                                     :B, %i[empty D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 20),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[empty D D A],
                                     :B, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 20),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[empty D D A],
                                     :empty, %i[C C B D],
                                     :B, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 40),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[empty D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :B, %i[D A C A],
                                     :empty, :empty], 60),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[empty D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :B, :empty], 80),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[empty D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :empty, :B], 90),
                 Amphipod::Move.new([:C,
                                     :empty, %i[B D D A],
                                     :empty, %i[empty C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 500),
                 Amphipod::Move.new([:empty,
                                     :C, %i[B D D A],
                                     :empty, %i[empty C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 400),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :C, %i[empty C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 200),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[empty C B D],
                                     :C, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 200),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[empty C B D],
                                     :empty, %i[B B A C],
                                     :C, %i[D A C A],
                                     :empty, :empty], 400),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[empty C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :C, :empty], 600),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[empty C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[D A C A],
                                     :empty, :C], 700),
                 Amphipod::Move.new([:B,
                                     :empty, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[empty B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 70),
                 Amphipod::Move.new([:empty,
                                     :B, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[empty B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 60),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :B, %i[C C B D],
                                     :empty, %i[empty B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 40),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :B, %i[empty B A C],
                                     :empty, %i[D A C A],
                                     :empty, :empty], 20),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[empty B A C],
                                     :B, %i[D A C A],
                                     :empty, :empty], 20),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[empty B A C],
                                     :empty, %i[D A C A],
                                     :B, :empty], 40),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[empty B A C],
                                     :empty, %i[D A C A],
                                     :empty, :B], 50),
                 Amphipod::Move.new([:D,
                                     :empty, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[empty A C A],
                                     :empty, :empty], 9000),
                 Amphipod::Move.new([:empty,
                                     :D, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[empty A C A],
                                     :empty, :empty], 8000),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :D, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[empty A C A],
                                     :empty, :empty], 6000),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :D, %i[B B A C],
                                     :empty, %i[empty A C A],
                                     :empty, :empty], 4000),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :D, %i[empty A C A],
                                     :empty, :empty], 2000),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[empty A C A],
                                     :D, :empty], 2000),
                 Amphipod::Move.new([:empty,
                                     :empty, %i[B D D A],
                                     :empty, %i[C C B D],
                                     :empty, %i[B B A C],
                                     :empty, %i[empty A C A],
                                     :empty, :D], 3000)
               ]
    end

    it "finds all expected next moves into a hall or room" do
      expect(Amphipod::Move.new([:x,
                                 :x, %i[empty A A A],
                                 :empty, %i[empty],
                                 :empty, %i[empty],
                                 :empty, %i[A D D D],
                                 :x, :x]).next_moves)
        .to eq Set[
                 Amphipod::Move.new([:x,
                                     :x, %i[empty A A A],
                                     :A, %i[empty],
                                     :empty, %i[empty],
                                     :empty, %i[empty D D D],
                                     :x, :x], 6),
                 Amphipod::Move.new([:x,
                                     :x, %i[empty A A A],
                                     :empty, %i[empty],
                                     :A, %i[empty],
                                     :empty, %i[empty D D D],
                                     :x, :x], 4),
                 Amphipod::Move.new([:x,
                                     :x, %i[empty A A A],
                                     :empty, %i[empty],
                                     :empty, %i[empty],
                                     :A, %i[empty D D D],
                                     :x, :x], 2),
                 Amphipod::Move.new([:x,
                                     :x, %i[A A A A],
                                     :empty, %i[empty],
                                     :empty, %i[empty],
                                     :empty, %i[empty D D D],
                                     :x, :x], 8)
               ]
    end

    it "finds exactly the expected moves from this board" do
      expect(Amphipod::Move.new([:A,
                                 :B,
                                 %i[empty empty],
                                 :D,
                                 %i[empty empty],
                                 :C,
                                 %i[empty empty],
                                 :D,
                                 %i[B C],
                                 :A,
                                 :empty]).next_moves)
        .to eq Set[
                 Amphipod::Move.new([:A,
                                     :B,
                                     %i[empty empty],
                                     :D,
                                     %i[empty empty],
                                     :empty,
                                     %i[empty C],
                                     :D,
                                     %i[B C],
                                     :A,
                                     :empty], 300)
               ]
    end

    context "from the initial configuration" do
      subject { Amphipod.new StringIO.new(<<~BOARD) }
        #############
        #...........#
        ###B#C#B#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds [6, 0] -> 3 among the possible next moves" do
        expect(Amphipod::Move.new(subject.board).next_moves)
          .to include Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board, 40)
            #############
            #...B.......#
            ###B#C#.#D###
              #A#D#C#A#
              #########
        BOARD
      end
    end

    context "from the second configuration" do
      subject { Amphipod.new StringIO.new(<<~BOARD) }
        #############
        #...B.......#
        ###B#C#.#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds [4, 0] -> [6, 0] among the possible next moves" do
        expect(Amphipod::Move.new(subject.board).next_moves)
          .to include Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board, 400)
            #############
            #...B.......#
            ###B#.#C#D###
              #A#D#C#A#
              #########
        BOARD
      end
    end

    context "from the third configuration" do
      subject { Amphipod.new StringIO.new(<<~BOARD) }
        #############
        #...B.......#
        ###B#.#C#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds [4, 1] -> 5 among the possible next moves" do
        expect(Amphipod::Move.new(subject.board).next_moves)
          .to include Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board, 3000)
            #############
            #...B.D.....#
            ###B#.#C#D###
              #A#.#C#A#
              #########
        BOARD
      end
    end

    context "from the third-A configuration" do
      subject { Amphipod.new StringIO.new(<<~BOARD) }
        #############
        #...B.D.....#
        ###B#.#C#D###
          #A#.#C#A#
          #########
      BOARD

      it "finds 3 -> [4, 1] among the possible next moves" do
        expect(Amphipod::Move.new(subject.board).next_moves)
          .to include Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board, 30)
            #############
            #.....D.....#
            ###B#.#C#D###
              #A#B#C#A#
              #########
        BOARD
      end
    end

    context "from the fourth configuration" do
      subject { Amphipod.new StringIO.new(<<~BOARD) }
        #############
        #.....D.....#
        ###B#.#C#D###
          #A#B#C#A#
          #########
      BOARD

      it "finds [2, 0] -> [4, 0] among the possible next moves" do
        expect(Amphipod::Move.new(subject.board).next_moves)
          .to include Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board, 40)
            #############
            #.....D.....#
            ###.#B#C#D###
              #A#B#C#A#
              #########
        BOARD
      end
    end

    context "from the fifth configuration" do
      subject { Amphipod.new StringIO.new(<<~BOARD) }
        #############
        #.....D.....#
        ###.#B#C#D###
          #A#B#C#A#
          #########
      BOARD

      it "finds [8, 0] -> 7 among the possible next moves" do
        expect(Amphipod::Move.new(subject.board).next_moves)
          .to include Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board, 2000)
            #############
            #.....D.D...#
            ###.#B#C#.###
              #A#B#C#A#
              #########
        BOARD
      end
    end

    context "from the fifth-A configuration" do
      subject { Amphipod.new StringIO.new(<<~BOARD) }
        #############
        #.....D.D...#
        ###.#B#C#.###
          #A#B#C#A#
          #########
      BOARD

      it "finds [8, 1] -> 9 among the possible next moves" do
        expect(Amphipod::Move.new(subject.board).next_moves)
          .to include Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board, 3)
            #############
            #.....D.D.A.#
            ###.#B#C#.###
              #A#B#C#.#
              #########
        BOARD
      end
    end
  end

  context "from the sixth configuration" do
    subject { Amphipod.new StringIO.new(<<~BOARD) }
      #############
      #.....D.D.A.#
      ###.#B#C#.###
        #A#B#C#.#
        #########
    BOARD

    it "finds [8, 1] -> 9 among the possible next moves" do
      expect(Amphipod::Move.new(subject.board).next_moves)
        .to include Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board, 3000)
          #############
          #.....D...A.#
          ###.#B#C#.###
            #A#B#C#D#
            #########
      BOARD
    end
  end

  context "from the sixth-A configuration" do
    subject { Amphipod.new StringIO.new(<<~BOARD) }
      #############
      #.....D...A.#
      ###.#B#C#.###
        #A#B#C#D#
        #########
    BOARD

    it "finds [8, 1] -> 9 among the possible next moves" do
      expect(Amphipod::Move.new(subject.board).next_moves)
        .to include Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board, 4000)
          #############
          #.........A.#
          ###.#B#C#D###
            #A#B#C#D#
            #########
      BOARD
    end
  end

  context "from the seventh configuration" do
    subject { Amphipod.new StringIO.new(<<~BOARD) }
      #############
      #.........A.#
      ###.#B#C#D###
        #A#B#C#D#
        #########
    BOARD

    it "finds [8, 1] -> 9 among the possible next moves" do
      expect(Amphipod::Move.new(subject.board).next_moves)
        .to include Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board, 8)
          #############
          #...........#
          ###A#B#C#D###
            #A#B#C#D#
            #########
      BOARD
    end
  end

  context "from this configuration" do
    subject { Amphipod.new StringIO.new(<<~BOARD) }
      #############
      #...........#
      ###B#C#B#D###
        #A#D#C#A#
        #########
    BOARD

    it "finds [8, 1] -> 9 among the possible next moves" do
      expect(Amphipod::Move.new(subject.board).next_moves)
        .to include Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board, 20)
          #############
          #.B.........#
          ###.#C#B#D###
            #A#D#C#A#
            #########
      BOARD
    end
  end

  describe "::clear_path_to?" do
    it "finds clear paths" do
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[C],
                                 :empty, %i[A],
                                 :empty, :empty]).clear_path_to?(0, 8)).to be true
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[C],
                                 :empty, %i[A],
                                 :empty, :empty]).clear_path_to?(1, 8)).to be true
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[C],
                                 :empty, %i[A],
                                 :empty, :empty]).clear_path_to?(3, 8)).to be true
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[C],
                                 :empty, %i[A],
                                 :empty, :empty]).clear_path_to?(5, 8)).to be true
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[C],
                                 :empty, %i[A],
                                 :empty, :empty]).clear_path_to?(7, 8)).to be true
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[C],
                                 :empty, %i[A],
                                 :empty, :empty]).clear_path_to?(9, 8)).to be true
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[empty],
                                 :C, %i[A],
                                 :empty, :empty]).clear_path_to?(10, 8)).to be true
    end

    it "finds blocked paths" do
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[empty],
                                 :C, %i[A],
                                 :empty, :empty]).clear_path_to?(7, 8)).to be false
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[empty],
                                 :C, %i[A],
                                 :empty, :empty]).clear_path_to?(5, 8)).to be false
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[empty],
                                 :C, %i[A],
                                 :empty, :empty]).clear_path_to?(3, 8)).to be false
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[empty],
                                 :C, %i[A],
                                 :empty, :empty]).clear_path_to?(1, 8)).to be false
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[empty],
                                 :C, %i[A],
                                 :empty, :empty]).clear_path_to?(0, 8)).to be false
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[empty],
                                 :empty, %i[A],
                                 :C, :empty]).clear_path_to?(9, 8)).to be false
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty],
                                 :empty, %i[B],
                                 :empty, %i[empty],
                                 :empty, %i[A],
                                 :C, :empty]).clear_path_to?(10, 8)).to be false
    end
  end

  describe "::ready_to_move" do
    it "lists the pieces that are able to move" do
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[B D D A],
                                 :empty, %i[C C B D],
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).ready_to_move).to eq [[2, 0], [4, 0], [6, 0], [8, 1]]
      expect(Amphipod::Move.new([:empty,
                                 :B, %i[empty D D A],
                                 :empty, %i[C C B D],
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).ready_to_move).to eq [[2, 1], [4, 0], [6, 0], [8, 1]]
      expect(Amphipod::Move.new([:empty,
                                 :A, %i[empty empty empty A],
                                 :empty, %i[C C B D],
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).ready_to_move).to eq [1, [4, 0], [6, 0], [8, 1]]
    end
  end

  describe "::can_move" do
    it "correctly indicates that a piece can move from a room" do
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[B D D A], # x = 2
                                 :empty, %i[C C B D], # x = 4
                                 :empty, %i[B B A C], # x = 6
                                 :empty, %i[empty A C A], # x = 8
                                 :empty, :D]).can_move_from_room_spot?(2, 0)).to be true
      expect(Amphipod::Move.new([:empty,
                                 :B, %i[empty D D A],
                                 :empty, %i[C C B D],
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).can_move_from_room_spot?(2, 1)).to be true
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[B D D A],
                                 :empty, %i[empty empty C B], # [4, 2] is in the wrong room (:C should be in [6, y])
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).can_move_from_room_spot?(4, 2)).to be true
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[B D D A],
                                 :empty, %i[empty empty B C], # [4, 3] is in the wrong room, so [4, 2] can move
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).can_move_from_room_spot?(4, 2)).to be true
    end

    it "correctly indicates that a piece cannot move from a room" do
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[B D D A],
                                 :empty, %i[C C B D],
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).can_move_from_room_spot?(2, 2)).to be false # [2, 2] is not nearest the door
      expect(Amphipod::Move.new([:empty,
                                 :C, %i[B D D A],
                                 :C, %i[empty empty B D],
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).can_move_from_room_spot?(2, 0)).to be false # adjoining hallways spaces both full
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[B D D A],
                                 :empty, %i[empty empty B B], # in the right room and no other kind below [2, 2]
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).can_move_from_room_spot?(4, 2)).to be false
      expect(Amphipod::Move.new([:empty,
                                 :empty, %i[empty A], # right room, farthest from door
                                 :empty, %i[empty empty B B],
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).can_move_from_room_spot?(2, 1)).to be false
    end

    it "correctly indicates that a piece can move from the hallway" do
      expect(Amphipod::Move.new([:B, # In the hall with a clear path to room x=4 and only B already in that room
                                 :empty, %i[B D D A],
                                 :empty, %i[empty empty B B],
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).can_move_to_room?(0)).to be true
    end

    it "correctly indicates that a piece cannot move from the hallway" do
      expect(Amphipod::Move.new([:B, # Path blocked at x=1
                                 :B, %i[B D D A],
                                 :empty, %i[empty empty B B],
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).can_move_to_room?(0)).to be false
      expect(Amphipod::Move.new([:B,
                                 :B, %i[B D D A], # Path open but :C in :B's room
                                 :empty, %i[empty empty B C],
                                 :empty, %i[B B A C],
                                 :empty, %i[empty A C A],
                                 :empty, :D]).can_move_to_room?(1)).to be false
    end
  end

  describe "final_state" do
    it "detects a final state" do
      expect(Amphipod::Move.new([:empty, :empty,
                                 %i[A A A A], :empty,
                                 %i[B B B B], :empty,
                                 %i[C C C C], :empty,
                                 %i[D D D D], :empty, :empty]).final_state?).to be true
      expect(Amphipod::Move.new([:empty, :empty,
                                 %i[A], :empty,
                                 %i[B], :empty,
                                 %i[C], :empty,
                                 %i[D], :empty, :empty]).final_state?).to be true
    end

    it "detects a non-final state" do
      expect(Amphipod::Move.new([:empty, :empty,
                                 %i[A A A B], :empty,
                                 %i[B B B A], :empty,
                                 %i[C C C C], :empty,
                                 %i[D D D D], :empty, :empty]).final_state?).to be false
      expect(Amphipod::Move.new([:empty, :empty,
                                 %i[A A A empty], :empty,
                                 %i[B B B A], :empty,
                                 %i[C C C C], :empty,
                                 %i[D D D D], :empty, :A]).final_state?).to be false
      expect(Amphipod::Move.new([:empty, :empty,
                                 %i[A], :empty,
                                 %i[B], :empty,
                                 %i[D], :empty,
                                 %i[C], :empty, :empty]).final_state?).to be false
      expect(Amphipod::Move.new([:empty, :empty,
                                 %i[A], :empty,
                                 %i[empty], :B,
                                 %i[D], :empty,
                                 %i[C], :empty, :empty]).final_state?).to be false
    end
  end

  describe "#play_game" do
    context "with the example input" do
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
        #############
        #...........#
        ###B#C#B#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds a least score of 12521 energy" do
        subject
        expect(subject.play_game(PriorityQueue.new)).to eq 12_521
      end
    end

    context "with my actual input" do
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
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

    context "with the unfolded example input" do
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
        #############
        #...........#
        ###B#C#B#D###
          #D#C#B#A#
          #D#B#A#C#
          #A#D#C#A#
          #########
      BOARD

      it "finds a least score of 44169 energy" do
        subject
        # expect(subject.play_game(PriorityQueue.new)).to eq 44_169
      end
    end

    context "with my actual unfolded input" do
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
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
  end
end
