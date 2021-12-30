# frozen_string_literal: true

RSpec.describe AoC2021::PriorityQueue do
  describe "#next" do
    context "with provided input" do
      it "returns nil when the queue is empty" do
        expect(subject.next).to be nil
      end

      it "returns the expected item" do
        # subject << [board: :a, score: 2, history: :c]
        # expect(subject.next).to eq [board: :a, score: 2, history: :c]
      end
    end
  end

  describe "#<<" do
    it "adds a single item to the queue" do
      # subject << [:a, 2, :c]
      # expect(subject.next).to eq [:a, 2, :c]
    end
  end

  # describe "#+" do
  #   it "adds two items to the queue" do
  #     subject + [[:a, 7, :c], [:d, 2, :f]]
  #     expect(subject.next).to eq [:d, 2, :f]
  #     expect(subject.next).to eq [:a, 7, :c]
  #     expect(subject.next).to be nil
  #   end
  # end
end
