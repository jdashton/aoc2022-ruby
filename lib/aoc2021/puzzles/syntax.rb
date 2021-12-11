# frozen_string_literal: true

module AoC2021
  # Segments implements the solutions for Day 8.
  class Syntax
    def initialize(file)
      @lines         = file.readlines(chomp: true)
      @illegal_lines = []
    end

    def illegal_points
      @lines.reduce(0, &method(:find_illegal_syntax))
    end

    def autocomplete
      illegal_points
      scores = (@lines - @illegal_lines).map { |line| PartialString.new line }
                                        .map(&:complete_string)
                                        .map(&:score_string)
                                        .sort
      scores[scores.size / 2]
    end

    private

    POINTS = {
      ")" => 3,
      "]" => 57,
      "}" => 1197,
      ">" => 25_137
    }.freeze

    MATCHING_BRACKET = {
      ")" => "(",
      "]" => "[",
      "}" => "{",
      ">" => "<"
    }.freeze

    CLOSING_BRACKET = MATCHING_BRACKET.invert

    OPENERS = Set.new(MATCHING_BRACKET.values)

    # Encapsulates operations on a stack of bracket characters
    class BracketStack
      extend Forwardable
      def_instance_delegators :@stack, :push, :pop

      def initialize
        @stack = []
      end
    end

    def find_illegal_syntax(acc, char_string, buffer = [])
      char_string.chars.each do |char|
        next buffer.push(char) if char in OPENERS

        next if buffer.pop == MATCHING_BRACKET[char]

        break acc = save_and_score(acc, char, char_string)
      end
      acc
    end

    def save_and_score(acc, char, char_string)
      @illegal_lines.push(char_string)
      acc + POINTS[char]
    end

    # Encapsulates finding brackets to close an incomplete string
    class PartialString
      attr_reader :str

      def initialize(str)
        @str = str
      end

      CLOSERS = Set.new(MATCHING_BRACKET.keys)

      def complete_string(valid_closers = 0, missing_closers = [])
        @str.chars.reverse.each do |char|
          next valid_closers += 1 if char in CLOSERS

          next valid_closers -= 1 if valid_closers.positive?

          missing_closers.push(CLOSING_BRACKET[char])
        end
        CompletionString.new(missing_closers.join)
      end
    end

    # Encapsulates scoring of a completion string
    class CompletionString
      attr_reader :str

      def initialize(str)
        @str = str
      end

      COMPLETION_POINTS = {
        ")" => 1,
        "]" => 2,
        "}" => 3,
        ">" => 4
      }.freeze

      def score_string
        @str.chars.reduce(0) { |acc, char| (acc * 5) + COMPLETION_POINTS[char] }
      end

      private

    end
  end
end
