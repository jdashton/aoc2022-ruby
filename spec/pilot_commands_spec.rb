# frozen_string_literal: true

require "aoc2021/pilot_commands"

RSpec.describe AoC2021::PilotCommands do
  describe "#exec_commands" do
    context "with 'forward 10/down 1' it reaches 10" do
      subject { AoC2021::PilotCommands.new StringIO.new(<<~COMMANDS) }
        forward 10
        down 1
      COMMANDS

      it "reaches 10" do
        expect(subject.exec_commands).to eq 10
      end
    end

    context "with provided test data" do
      subject { AoC2021::PilotCommands.new StringIO.new(<<~COMMANDS) }
        forward 5
        down 5
        forward 8
        up 3
        down 8
        forward 2
      COMMANDS

      it "reaches 150" do
        expect(subject.exec_commands).to eq 150
      end
    end
  end

  describe "#exec_with_aim" do
    context "with provided test data" do
      subject { AoC2021::PilotCommands.new StringIO.new(<<~COMMANDS) }
        forward 5
        down 5
        forward 8
        up 3
        down 8
        forward 2
      COMMANDS

      it "reaches 900" do
        expect(subject.exec_with_aim).to eq 900
      end
    end
  end
end
