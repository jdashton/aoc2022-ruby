# frozen_string_literal: true

include AoC2021

RSpec.describe Amphipod do
  describe "::next_moves" do
    it "finds the expected next moves from the hall" do
      expect(Amphipod::Move.new([:D,
                                 nil, %i[A A A A],
                                 nil, %i[B B B B],
                                 nil, %i[C C C C],
                                 nil, [nil, :D, :D, :D],
                                 nil, nil]).next_moves)
        .to eq Set[
                 Amphipod::Move.new([nil,
                                     nil, %i[A A A A],
                                     nil, %i[B B B B],
                                     nil, %i[C C C C],
                                     nil, %i[D D D D],
                                     nil, nil], 9000)
               ]
      expect(Amphipod::Move.new([nil,
                                 nil, %i[A A A A],
                                 nil, %i[B B B B],
                                 nil, %i[C C C C],
                                 nil, [nil, :D, :D, :D],
                                 nil, :D]).next_moves)
        .to eq Set[
                 Amphipod::Move.new([nil,
                                     nil, %i[A A A A],
                                     nil, %i[B B B B],
                                     nil, %i[C C C C],
                                     nil, %i[D D D D],
                                     nil, nil], 3000)
               ]
    end

    it "finds one expected next move" do
      expect(Amphipod::Move.new([:x,
                                 :x, %i[A A A A],
                                 :x, %i[B B B B],
                                 :x, %i[D C C C],
                                 :x, %i[A D D D],
                                 nil, :x]).next_moves)
        .to eq Set[
                 Amphipod::Move.new([:x,
                                     :x, %i[A A A A],
                                     :x, %i[B B B B],
                                     :x, %i[D C C C],
                                     :x, [nil] + %i[D D D],
                                     :A, :x], 2)
               ]
    end

    it "finds all expected next moves into a hallway spot" do
      expect(Amphipod::Move.new([nil,
                                 nil, %i[B D D A],
                                 nil, %i[C C B D],
                                 nil, %i[B B A C],
                                 nil, %i[D A C A],
                                 nil, nil]).next_moves)
        .to eq Set[
                 Amphipod::Move.new([:B,
                                     nil, [nil] + %i[D D A],
                                     nil, %i[C C B D],
                                     nil, %i[B B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 30),
                 Amphipod::Move.new([nil,
                                     :B, [nil] + %i[D D A],
                                     nil, %i[C C B D],
                                     nil, %i[B B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 20),
                 Amphipod::Move.new([nil,
                                     nil, [nil] + %i[D D A],
                                     :B, %i[C C B D],
                                     nil, %i[B B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 20),
                 Amphipod::Move.new([nil,
                                     nil, [nil] + %i[D D A],
                                     nil, %i[C C B D],
                                     :B, %i[B B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 40),
                 Amphipod::Move.new([nil,
                                     nil, [nil] + %i[D D A],
                                     nil, %i[C C B D],
                                     nil, %i[B B A C],
                                     :B, %i[D A C A],
                                     nil, nil], 60),
                 Amphipod::Move.new([nil,
                                     nil, [nil] + %i[D D A],
                                     nil, %i[C C B D],
                                     nil, %i[B B A C],
                                     nil, %i[D A C A],
                                     :B, nil], 80),
                 Amphipod::Move.new([nil,
                                     nil, [nil] + %i[D D A],
                                     nil, %i[C C B D],
                                     nil, %i[B B A C],
                                     nil, %i[D A C A],
                                     nil, :B], 90),
                 Amphipod::Move.new([:C,
                                     nil, %i[B D D A],
                                     nil, [nil] + %i[C B D],
                                     nil, %i[B B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 500),
                 Amphipod::Move.new([nil,
                                     :C, %i[B D D A],
                                     nil, [nil] + %i[C B D],
                                     nil, %i[B B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 400),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     :C, [nil] + %i[C B D],
                                     nil, %i[B B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 200),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, [nil] + %i[C B D],
                                     :C, %i[B B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 200),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, [nil] + %i[C B D],
                                     nil, %i[B B A C],
                                     :C, %i[D A C A],
                                     nil, nil], 400),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, [nil] + %i[C B D],
                                     nil, %i[B B A C],
                                     nil, %i[D A C A],
                                     :C, nil], 600),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, [nil] + %i[C B D],
                                     nil, %i[B B A C],
                                     nil, %i[D A C A],
                                     nil, :C], 700),
                 Amphipod::Move.new([:B,
                                     nil, %i[B D D A],
                                     nil, %i[C C B D],
                                     nil, [nil] + %i[B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 70),
                 Amphipod::Move.new([nil,
                                     :B, %i[B D D A],
                                     nil, %i[C C B D],
                                     nil, [nil] + %i[B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 60),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     :B, %i[C C B D],
                                     nil, [nil] + %i[B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 40),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, %i[C C B D],
                                     :B, [nil] + %i[B A C],
                                     nil, %i[D A C A],
                                     nil, nil], 20),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, %i[C C B D],
                                     nil, [nil] + %i[B A C],
                                     :B, %i[D A C A],
                                     nil, nil], 20),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, %i[C C B D],
                                     nil, [nil] + %i[B A C],
                                     nil, %i[D A C A],
                                     :B, nil], 40),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, %i[C C B D],
                                     nil, [nil] + %i[B A C],
                                     nil, %i[D A C A],
                                     nil, :B], 50),
                 Amphipod::Move.new([:D,
                                     nil, %i[B D D A],
                                     nil, %i[C C B D],
                                     nil, %i[B B A C],
                                     nil, [nil] + %i[A C A],
                                     nil, nil], 9000),
                 Amphipod::Move.new([nil,
                                     :D, %i[B D D A],
                                     nil, %i[C C B D],
                                     nil, %i[B B A C],
                                     nil, [nil] + %i[A C A],
                                     nil, nil], 8000),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     :D, %i[C C B D],
                                     nil, %i[B B A C],
                                     nil, [nil] + %i[A C A],
                                     nil, nil], 6000),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, %i[C C B D],
                                     :D, %i[B B A C],
                                     nil, [nil] + %i[A C A],
                                     nil, nil], 4000),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, %i[C C B D],
                                     nil, %i[B B A C],
                                     :D, [nil] + %i[A C A],
                                     nil, nil], 2000),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, %i[C C B D],
                                     nil, %i[B B A C],
                                     nil, [nil] + %i[A C A],
                                     :D, nil], 2000),
                 Amphipod::Move.new([nil,
                                     nil, %i[B D D A],
                                     nil, %i[C C B D],
                                     nil, %i[B B A C],
                                     nil, [nil] + %i[A C A],
                                     nil, :D], 3000)
               ]
    end

    it "finds all expected next moves into a hall or room" do
      expect(Amphipod::Move.new([:x,
                                 :x, [nil] + %i[A A A],
                                 nil, [nil],
                                 nil, [nil],
                                 nil, %i[A D D D],
                                 :x, :x]).next_moves)
        .to eq Set[
                 Amphipod::Move.new([:x,
                                     :x, [nil] + %i[A A A],
                                     :A, [nil],
                                     nil, [nil],
                                     nil, [nil] + %i[D D D],
                                     :x, :x], 6),
                 Amphipod::Move.new([:x,
                                     :x, [nil] + %i[A A A],
                                     nil, [nil],
                                     :A, [nil],
                                     nil, [nil] + %i[D D D],
                                     :x, :x], 4),
                 Amphipod::Move.new([:x,
                                     :x, [nil] + %i[A A A],
                                     nil, [nil],
                                     nil, [nil],
                                     :A, [nil] + %i[D D D],
                                     :x, :x], 2),
                 Amphipod::Move.new([:x,
                                     :x, %i[A A A A],
                                     nil, [nil],
                                     nil, [nil],
                                     nil, [nil] + %i[D D D],
                                     :x, :x], 8)
               ]
    end

    it "finds exactly the expected moves from this board" do
      expect(Amphipod::Move.new([:A,
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
                 Amphipod::Move.new([:A,
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
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, %i[C],
                                 nil, %i[A],
                                 nil, nil]).clear_path_to?(0, 8)).to be true
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, %i[C],
                                 nil, %i[A],
                                 nil, nil]).clear_path_to?(1, 8)).to be true
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, %i[C],
                                 nil, %i[A],
                                 nil, nil]).clear_path_to?(3, 8)).to be true
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, %i[C],
                                 nil, %i[A],
                                 nil, nil]).clear_path_to?(5, 8)).to be true
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, %i[C],
                                 nil, %i[A],
                                 nil, nil]).clear_path_to?(7, 8)).to be true
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, %i[C],
                                 nil, %i[A],
                                 nil, nil]).clear_path_to?(9, 8)).to be true
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, [nil],
                                 :C, %i[A],
                                 nil, nil]).clear_path_to?(10, 8)).to be true
    end

    it "finds blocked paths" do
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, [nil],
                                 :C, %i[A],
                                 nil, nil]).clear_path_to?(7, 8)).to be false
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, [nil],
                                 :C, %i[A],
                                 nil, nil]).clear_path_to?(5, 8)).to be false
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, [nil],
                                 :C, %i[A],
                                 nil, nil]).clear_path_to?(3, 8)).to be false
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, [nil],
                                 :C, %i[A],
                                 nil, nil]).clear_path_to?(1, 8)).to be false
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, [nil],
                                 :C, %i[A],
                                 nil, nil]).clear_path_to?(0, 8)).to be false
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, [nil],
                                 nil, %i[A],
                                 :C, nil]).clear_path_to?(9, 8)).to be false
      expect(Amphipod::Move.new([nil,
                                 nil, [nil],
                                 nil, %i[B],
                                 nil, [nil],
                                 nil, %i[A],
                                 :C, nil]).clear_path_to?(10, 8)).to be false
    end
  end

  describe "::ready_to_move" do
    it "lists the pieces that are able to move" do
      expect(Amphipod::Move.new([nil,
                                 nil, %i[B D D A],
                                 nil, %i[C C B D],
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).ready_to_move).to eq [[2, 0], [4, 0], [6, 0], [8, 1]]
      expect(Amphipod::Move.new([nil,
                                 :B, [nil] + %i[D D A],
                                 nil, %i[C C B D],
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).ready_to_move).to eq [[2, 1], [4, 0], [6, 0], [8, 1]]
      expect(Amphipod::Move.new([nil,
                                 :A, [nil] + [nil, nil, :A],
                                 nil, %i[C C B D],
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).ready_to_move).to eq [1, [4, 0], [6, 0], [8, 1]]
    end
  end

  describe "::can_move" do
    it "correctly indicates that a piece can move from a room" do
      expect(Amphipod::Move.new([nil,
                                 nil, %i[B D D A], # x = 2
                                 nil, %i[C C B D], # x = 4
                                 nil, %i[B B A C], # x = 6
                                 nil, [nil] + %i[A C A], # x = 8
                                 nil, :D]).can_move_from_room_spot?(2, 0)).to be true
      expect(Amphipod::Move.new([nil,
                                 :B, [nil] + %i[D D A],
                                 nil, %i[C C B D],
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).can_move_from_room_spot?(2, 1)).to be true
      expect(Amphipod::Move.new([nil,
                                 nil, %i[B D D A],
                                 nil, [nil] + [nil] + %i[C B], # [4, 2] is in the wrong room (:C should be in [6, y])
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).can_move_from_room_spot?(4, 2)).to be true
      expect(Amphipod::Move.new([nil,
                                 nil, %i[B D D A],
                                 nil, [nil] + [nil] + %i[B C], # [4, 3] is in the wrong room, so [4, 2] can move
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).can_move_from_room_spot?(4, 2)).to be true
    end

    it "correctly indicates that a piece cannot move from a room" do
      expect(Amphipod::Move.new([nil,
                                 nil, %i[B D D A],
                                 nil, %i[C C B D],
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).can_move_from_room_spot?(2, 2)).to be false # [2, 2] is not nearest the door
      expect(Amphipod::Move.new([nil,
                                 :C, %i[B D D A],
                                 :C, [nil] + [nil] + %i[B D],
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).can_move_from_room_spot?(2, 0)).to be false # adjoining hallways spaces both full
      expect(Amphipod::Move.new([nil,
                                 nil, %i[B D D A],
                                 nil, [nil] + [nil] + %i[B B], # in the right room and no other kind below [2, 2]
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).can_move_from_room_spot?(4, 2)).to be false
      expect(Amphipod::Move.new([nil,
                                 nil, [nil] + %i[A], # right room, farthest from door
                                 nil, [nil] + [nil] + %i[B B],
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).can_move_from_room_spot?(2, 1)).to be false
    end

    it "correctly indicates that a piece can move from the hallway" do
      expect(Amphipod::Move.new([:B, # In the hall with a clear path to room x=4 and only B already in that room
                                 nil, %i[B D D A],
                                 nil, [nil] + [nil] + %i[B B],
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).can_move_to_room?(0)).to be true
    end

    it "correctly indicates that a piece cannot move from the hallway" do
      expect(Amphipod::Move.new([:B, # Path blocked at x=1
                                 :B, %i[B D D A],
                                 nil, [nil] + [nil] + %i[B B],
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).can_move_to_room?(0)).to be false
      expect(Amphipod::Move.new([:B,
                                 :B, %i[B D D A], # Path open but :C in :B's room
                                 nil, [nil] + [nil] + %i[B C],
                                 nil, %i[B B A C],
                                 nil, [nil] + %i[A C A],
                                 nil, :D]).can_move_to_room?(1)).to be false
    end
  end

  describe "final_state" do
    it "detects a final state" do
      expect(Amphipod::Move.new([nil, nil,
                                 %i[A A A A], nil,
                                 %i[B B B B], nil,
                                 %i[C C C C], nil,
                                 %i[D D D D], nil, nil]).final_state?).to be true
      expect(Amphipod::Move.new([nil, nil,
                                 %i[A], nil,
                                 %i[B], nil,
                                 %i[C], nil,
                                 %i[D], nil, nil]).final_state?).to be true
    end

    it "detects a non-final state" do
      expect(Amphipod::Move.new([nil, nil,
                                 %i[A A A B], nil,
                                 %i[B B B A], nil,
                                 %i[C C C C], nil,
                                 %i[D D D D], nil, nil]).final_state?).to be false
      expect(Amphipod::Move.new([nil, nil,
                                 %i[A A A] + [nil], nil,
                                 %i[B B B A], nil,
                                 %i[C C C C], nil,
                                 %i[D D D D], nil, :A]).final_state?).to be false
      expect(Amphipod::Move.new([nil, nil,
                                 %i[A], nil,
                                 %i[B], nil,
                                 %i[D], nil,
                                 %i[C], nil, nil]).final_state?).to be false
      expect(Amphipod::Move.new([nil, nil,
                                 %i[A], nil,
                                 [nil], :B,
                                 %i[D], nil,
                                 %i[C], nil, nil]).final_state?).to be false
    end
  end

  describe "#exit_energy" do
    context "with the example input" do
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
        #############
        #...........#
        ###B#C#B#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds a cost of 3,122 energy for all non-homed pods to leave the initial rooms" do
        expect(subject.exit_energy(subject.prune(subject.board))).to eq 3_122
      end
    end
  end

  describe "#entry_energy" do
    context "with the example input" do
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
        #############
        #...........#
        ###B#C#B#D###
          #A#D#C#A#
          #########
      BOARD

      it "finds a cost of 3,131 energy to fill all rooms from the initial state" do
        expect(subject.entry_energy(subject.prune(subject.board))).to eq 3_131
      end
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
        # expect(subject.play_game(PriorityQueue.new)).to eq 12_521
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

    context "with vodik's input" do
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
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

      it "finds a cost of x to leave the rooms" do
        expect(subject.exit_energy(subject.prune(subject.board)))
          .to eq 10 + 2000 + 3000 + 100 + 200 + 30 + 4000 + 10 + 20 + 3 + 1000 + 2 + 300 + 4
      end

      it "finds a least score of 44169 energy" do
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

    context "with vodik's part 2 input" do
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
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

  describe "#play_vodik" do
    context "with the example input" do
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
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
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
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
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
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
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
        #############
        #...........#
        ###B#C#B#D###
          #D#C#B#A#
          #D#B#A#C#
          #A#D#C#A#
          #########
      BOARD

      it "finds a cost of x to leave the rooms" do
        expect(subject.exit_energy(subject.prune(subject.board)))
          .to eq 10 + 2000 + 3000 + 100 + 200 + 30 + 4000 + 10 + 20 + 3 + 1000 + 2 + 300 + 4
      end

      it "finds a least score of 44169 energy" do
        expect(subject.play_vodik(PriorityQueue.new)).to eq 44_169
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
        expect(subject.play_vodik(PriorityQueue.new)).to eq 43_567
      end
    end

    context "with vodik's part 2 input" do
      subject { Amphipod::Move.new(Amphipod.new(StringIO.new(<<~BOARD)).board) }
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
end
