# frozen_string_literal: true

require "aoc2021/puzzles/arithmetic_logic_unit"

RSpec.describe AoC2021::ArithmeticLogicUnit do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  describe "::largest_model_number" do
    it "finds the expected next moves from the hall" do
      expect(AoC2021::ArithmeticLogicUnit.largest_model_number)
        .to eq 99_999_999_999_999
    end
  end
end
