# frozen_string_literal: true

module AoC2021
  # Segments implements the solutions for Day 8.
  class Syntax
    def initialize(file)
      @lines         = file.readlines(chomp: true)
      @illegal_lines = []
    end

    MATCHING_BRACKET = {
      ")" => "(",
      "]" => "[",
      "}" => "{",
      ">" => "<"
    }.freeze

    # Encapsulates operations on lines that might be incomplete or illegal
    class UnknownLine
      extend Forwardable
      def_instance_delegators :@lines, :chars

      def initialize(line)
        @line   = line
        @buffer = []
      end

      OPENERS = Set.new(MATCHING_BRACKET.values)

      def find_illegal_syntax(acc, illegal_lines)
        @line.chars.each do |char|
          next @buffer.push(char) if char in OPENERS

          next if @buffer.pop == MATCHING_BRACKET[char]

          break acc = save_and_score(acc, char, illegal_lines)
        end
        acc
      end

      POINTS = {
        ")" => 3,
        "]" => 57,
        "}" => 1197,
        ">" => 25_137
      }.freeze

      def save_and_score(acc, char, illegal_lines)
        illegal_lines.push(@line)
        acc + POINTS[char]
      end
    end

    def illegal_points
      @lines.map { |line| UnknownLine.new line }.reduce(0) { |acc, line| line.find_illegal_syntax(acc, @illegal_lines) }
    end

    def autocomplete
      illegal_points
      scores = (@lines - @illegal_lines).map { |line| PartialString.new line }
                                        .map(&:complete_string)
                                        .map(&:score_string)
                                        .sort
      scores[scores.size / 2]
    end

    # Encapsulates finding brackets to close an incomplete string
    class PartialString
      attr_reader :str

      def initialize(str)
        @str           = str
        @valid_closers = 0
      end

      CLOSERS         = Set.new(MATCHING_BRACKET.keys)
      CLOSING_BRACKET = MATCHING_BRACKET.invert

      def complete_string
        @valid_closers = 0
        CompletionString.new(
          @str.chars.reverse.reduce([]) { |acc, char|
            next inc_closers(acc) if char in CLOSERS

            next dec_closers(acc) if @valid_closers.positive?

            acc + [CLOSING_BRACKET[char]]
          }.join
        )
      end

      private

      def dec_closers(acc)
        @valid_closers -= 1
        acc
      end

      def inc_closers(acc)
        @valid_closers += 1
        acc
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
    end
  end
end
