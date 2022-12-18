# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 6, we're looking for message headers
    class TuningTrouble
      def self.day06
        datastream = File.open('input/day06.txt') { |file| TuningTrouble.new file }
        puts "Day  6, Part One: The packet marker ends at character #{ datastream.packet_marker }."
        puts "Day  6, Part Two: The message marker ends at character #{ datastream.message_marker }."
        puts
      end

      def initialize(file)
        @chars = file.readlines(chomp: true).first.chars
      end

      def packet_marker
        @chars.each_cons(4).with_index do |msg, i|
          next if msg.uniq.length < 4

          return i + 4
        end
      end

      def message_marker
        @chars.each_cons(14).with_index do |msg, i|
          next if msg.uniq.length < 14

          return i + 14
        end
      end
    end
  end
end
