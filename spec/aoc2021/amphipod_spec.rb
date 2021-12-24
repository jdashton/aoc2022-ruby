# frozen_string_literal: true

require "aoc2021/puzzles/amphipod"

RSpec.describe AoC2021::Amphipod do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "::next_moves" do
    it "finds the expected next moves from the hall" do
      expect(AoC2021::Amphipod.next_moves([[:D,
                                            :empty, %i[A A A A],
                                            :empty, %i[B B B B],
                                            :empty, %i[C C C C],
                                            :empty, %i[empty D D D],
                                            :empty, :empty], 0]))
        .to eq Set[
                 [[:empty,
                   :empty, %i[A A A A],
                   :empty, %i[B B B B],
                   :empty, %i[C C C C],
                   :empty, %i[D D D D],
                   :empty, :empty], 9000]
               ]
      expect(AoC2021::Amphipod.next_moves([[:empty,
                                            :empty, %i[A A A A],
                                            :empty, %i[B B B B],
                                            :empty, %i[C C C C],
                                            :empty, %i[empty D D D],
                                            :empty, :D], 0]))
        .to eq Set[
                 [[:empty,
                   :empty, %i[A A A A],
                   :empty, %i[B B B B],
                   :empty, %i[C C C C],
                   :empty, %i[D D D D],
                   :empty, :empty], 3000]
               ]
    end

    it "finds the expected next moves" do
      expect(AoC2021::Amphipod.next_moves([[:x,
                                            :x, %i[A A A A],
                                            :x, %i[B B B B],
                                            :x, %i[C C C C],
                                            :x, %i[A D D D],
                                            :empty, :x], 0]))
        .to eq Set[
                 [[:x,
                   :x, %i[A A A A],
                   :x, %i[B B B B],
                   :x, %i[D C C C],
                   :x, %i[empty D D D],
                   :A, :x], 2]
               ]
      expect(AoC2021::Amphipod.next_moves([[:empty,
                                            :empty, %i[B D D A],
                                            :empty, %i[C C B D],
                                            :empty, %i[B B A C],
                                            :empty, %i[D A C A],
                                            :empty, :empty], 0]))
        .to eq Set[
                 [[:B,
                   :empty, %i[empty D D A],
                   :empty, %i[C C B D],
                   :empty, %i[B B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 30],
                 [[:empty,
                   :B, %i[empty D D A],
                   :empty, %i[C C B D],
                   :empty, %i[B B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 20],
                 [[:empty,
                   :empty, %i[empty D D A],
                   :B, %i[C C B D],
                   :empty, %i[B B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 20],
                 [[:empty,
                   :empty, %i[empty D D A],
                   :empty, %i[C C B D],
                   :B, %i[B B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 40],
                 [[:empty,
                   :empty, %i[empty D D A],
                   :empty, %i[C C B D],
                   :empty, %i[B B A C],
                   :B, %i[D A C A],
                   :empty, :empty], 60],
                 [[:empty,
                   :empty, %i[empty D D A],
                   :empty, %i[C C B D],
                   :empty, %i[B B A C],
                   :empty, %i[D A C A],
                   :B, :empty], 80],
                 [[:empty,
                   :empty, %i[empty D D A],
                   :empty, %i[C C B D],
                   :empty, %i[B B A C],
                   :empty, %i[D A C A],
                   :empty, :B], 90],
                 [[:C,
                   :empty, %i[B D D A],
                   :empty, %i[empty C B D],
                   :empty, %i[B B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 500],
                 [[:empty,
                   :C, %i[B D D A],
                   :empty, %i[empty C B D],
                   :empty, %i[B B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 400],
                 [[:empty,
                   :empty, %i[B D D A],
                   :C, %i[empty C B D],
                   :empty, %i[B B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 200],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[empty C B D],
                   :C, %i[B B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 200],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[empty C B D],
                   :empty, %i[B B A C],
                   :C, %i[D A C A],
                   :empty, :empty], 400],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[empty C B D],
                   :empty, %i[B B A C],
                   :empty, %i[D A C A],
                   :C, :empty], 600],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[empty C B D],
                   :empty, %i[B B A C],
                   :empty, %i[D A C A],
                   :empty, :C], 700],
                 [[:B,
                   :empty, %i[B D D A],
                   :empty, %i[C C B D],
                   :empty, %i[empty B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 70],
                 [[:empty,
                   :B, %i[B D D A],
                   :empty, %i[C C B D],
                   :empty, %i[empty B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 60],
                 [[:empty,
                   :empty, %i[B D D A],
                   :B, %i[C C B D],
                   :empty, %i[empty B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 40],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[C C B D],
                   :B, %i[empty B A C],
                   :empty, %i[D A C A],
                   :empty, :empty], 20],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[C C B D],
                   :empty, %i[empty B A C],
                   :B, %i[D A C A],
                   :empty, :empty], 20],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[C C B D],
                   :empty, %i[empty B A C],
                   :empty, %i[D A C A],
                   :B, :empty], 40],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[C C B D],
                   :empty, %i[empty B A C],
                   :empty, %i[D A C A],
                   :empty, :B], 50],
                 [[:D,
                   :empty, %i[B D D A],
                   :empty, %i[C C B D],
                   :empty, %i[B B A C],
                   :empty, %i[empty A C A],
                   :empty, :empty], 9000],
                 [[:empty,
                   :D, %i[B D D A],
                   :empty, %i[C C B D],
                   :empty, %i[B B A C],
                   :empty, %i[empty A C A],
                   :empty, :empty], 8000],
                 [[:empty,
                   :empty, %i[B D D A],
                   :D, %i[C C B D],
                   :empty, %i[B B A C],
                   :empty, %i[empty A C A],
                   :empty, :empty], 6000],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[C C B D],
                   :D, %i[B B A C],
                   :empty, %i[empty A C A],
                   :empty, :empty], 4000],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[C C B D],
                   :empty, %i[B B A C],
                   :D, %i[empty A C A],
                   :empty, :empty], 2000],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[C C B D],
                   :empty, %i[B B A C],
                   :empty, %i[empty A C A],
                   :D, :empty], 2000],
                 [[:empty,
                   :empty, %i[B D D A],
                   :empty, %i[C C B D],
                   :empty, %i[B B A C],
                   :empty, %i[empty A C A],
                   :empty, :D], 3000]
               ]
    end
  end

  describe "::ready_to_move" do
    it "lists the pieces that are able to move" do
      expect(AoC2021::Amphipod.ready_to_move([:empty,
                                              :empty, %i[B D D A],
                                              :empty, %i[C C B D],
                                              :empty, %i[B B A C],
                                              :empty, %i[empty A C A],
                                              :empty, :D])).to eq [[2, 0], [4, 0], [6, 0], [8, 1]]
      expect(AoC2021::Amphipod.ready_to_move([:empty,
                                              :B, %i[empty D D A],
                                              :empty, %i[C C B D],
                                              :empty, %i[B B A C],
                                              :empty, %i[empty A C A],
                                              :empty, :D])).to eq [[2, 1], [4, 0], [6, 0], [8, 1]]
      expect(AoC2021::Amphipod.ready_to_move([:empty,
                                              :A, %i[empty empty empty A],
                                              :empty, %i[C C B D],
                                              :empty, %i[B B A C],
                                              :empty, %i[empty A C A],
                                              :empty, :D])).to eq [1, [4, 0], [6, 0], [8, 1]]
    end
  end

  describe "::can_move" do
    it "correctly indicates that a piece can move from a room" do
      expect(AoC2021::Amphipod.can_move?([:empty,
                                          :empty, %i[B D D A], # x = 2
                                          :empty, %i[C C B D], # x = 4
                                          :empty, %i[B B A C], # x = 6
                                          :empty, %i[empty A C A], # x = 8
                                          :empty, :D], [2, 0])).to be true
      expect(AoC2021::Amphipod.can_move?([:empty,
                                          :B, %i[empty D D A],
                                          :empty, %i[C C B D],
                                          :empty, %i[B B A C],
                                          :empty, %i[empty A C A],
                                          :empty, :D], [2, 1])).to be true
      expect(AoC2021::Amphipod.can_move?([:empty,
                                          :empty, %i[B D D A],
                                          :empty, %i[empty empty C B], # [4, 2] is in the wrong room (:C should be in [6, y])
                                          :empty, %i[B B A C],
                                          :empty, %i[empty A C A],
                                          :empty, :D], [4, 2])).to be true
      expect(AoC2021::Amphipod.can_move?([:empty,
                                          :empty, %i[B D D A],
                                          :empty, %i[empty empty B C], # [4, 3] is in the wrong room, so [4, 2] can move
                                          :empty, %i[B B A C],
                                          :empty, %i[empty A C A],
                                          :empty, :D], [4, 2])).to be true
    end

    it "correctly indicates that a piece cannot move from a room" do
      expect(AoC2021::Amphipod.can_move?([:empty,
                                          :empty, %i[B D D A],
                                          :empty, %i[C C B D],
                                          :empty, %i[B B A C],
                                          :empty, %i[empty A C A],
                                          :empty, :D], [2, 2])).to be false # [2, 2] is not nearest the door
      expect(AoC2021::Amphipod.can_move?([:empty,
                                          :C, %i[B D D A],
                                          :C, %i[empty empty B D],
                                          :empty, %i[B B A C],
                                          :empty, %i[empty A C A],
                                          :empty, :D], [2, 0])).to be false # adjoining hallways spaces both full
      expect(AoC2021::Amphipod.can_move?([:empty,
                                          :empty, %i[B D D A],
                                          :empty, %i[empty empty B B], # in the right room and no other kind below [2, 2]
                                          :empty, %i[B B A C],
                                          :empty, %i[empty A C A],
                                          :empty, :D], [4, 2])).to be false
      expect(AoC2021::Amphipod.can_move?([:empty,
                                          :empty, %i[empty A], # right room, farthest from door
                                          :empty, %i[empty empty B B],
                                          :empty, %i[B B A C],
                                          :empty, %i[empty A C A],
                                          :empty, :D], [2, 1])).to be false
    end

    it "correctly indicates that a piece can move from the hallway" do
      expect(AoC2021::Amphipod.can_move?([:B, # In the hall with a clear path to room x=4 and only B already in that room
                                          :empty, %i[B D D A],
                                          :empty, %i[empty empty B B],
                                          :empty, %i[B B A C],
                                          :empty, %i[empty A C A],
                                          :empty, :D], 0)).to be true
    end

    it "correctly indicates that a piece cannot move from the hallway" do
      expect(AoC2021::Amphipod.can_move?([:B, # Path blocked at x=1
                                          :B, %i[B D D A],
                                          :empty, %i[empty empty B B],
                                          :empty, %i[B B A C],
                                          :empty, %i[empty A C A],
                                          :empty, :D], 0)).to be false
      expect(AoC2021::Amphipod.can_move?([:B,
                                          :B, %i[B D D A], # Path open but :C in :B's room
                                          :empty, %i[empty empty B C],
                                          :empty, %i[B B A C],
                                          :empty, %i[empty A C A],
                                          :empty, :D], 1)).to be false
    end
  end

  describe "::final_state" do
    it "detects a final state" do
      expect(AoC2021::Amphipod.final_state?([:empty, :empty,
                                             %i[A A A A], :empty,
                                             %i[B B B B], :empty,
                                             %i[C C C C], :empty,
                                             %i[D D D D], :empty, :empty])).to be true
    end

    it "detects a non-final state" do
      expect(AoC2021::Amphipod.final_state?([:empty, :empty,
                                             %i[A A A B], :empty,
                                             %i[B B B A], :empty,
                                             %i[C C C C], :empty,
                                             %i[D D D D], :empty, :empty])).to be false
      expect(AoC2021::Amphipod.final_state?([:empty, :empty,
                                             %i[A A A empty], :empty,
                                             %i[B B B A], :empty,
                                             %i[C C C C], :empty,
                                             %i[D D D D], :empty, :A])).to be false
    end
  end
end
