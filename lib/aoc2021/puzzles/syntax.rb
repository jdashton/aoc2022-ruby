# frozen_string_literal: true

module AoC2021
  # Segments implements the solutions for Day 8.
  class Syntax
    def initialize(file)
      @lines         = file.readlines(chomp: true)
      @illegal_lines = []
    end

    POINTS = {
      ")" => 3,
      "]" => 57,
      "}" => 1197,
      ">" => 25_137
    }.freeze

    COMPLETION_POINTS = {
      ")" => 1,
      "]" => 2,
      "}" => 3,
      ">" => 4
    }.freeze

    MATCHING_BRACKET = {
      ")" => "(",
      "]" => "[",
      "}" => "{",
      ">" => "<"
    }

    CLOSING_BRACKET = MATCHING_BRACKET.invert

    OPENERS = Set["(", "[", "{", "<"]
    CLOSERS = Set[*POINTS.keys]

    def illegal_points
      @lines.reduce(0) do |acc, char_string|
        # puts "Start processing ---------- #{char_string}"
        stack        = []
        illegal_char = nil
        char_string.chars.each { |char|
          # puts "Processing #{char}"
          if char in OPENERS
            stack.push char
            # puts "Pushed #{char}, yielding #{stack}"
            next
          end

          last_char = stack.pop
          # puts " -- POPPED #{last_char}, yielding #{stack}"
          if last_char == MATCHING_BRACKET[char]
            # puts " -- found a valid match"
            next
          end

          # puts " -- MISMATCH #{last_char} #{char}"
          illegal_char = char
          break
        }
        @illegal_lines.push(char_string) if illegal_char
        # puts "Returning points for #{illegal_char}"
        acc + (POINTS[illegal_char] || 0)
      end
    end

    def complete_string(str)
      stack         = str.chars
      valid_segment = 0
      answer        = []
      stack.reverse.each do |char|
        if OPENERS.include?(char)
          if valid_segment.zero?
            answer.push(CLOSING_BRACKET[char])
          else
            valid_segment -= 1
          end
        else
          valid_segment += 1
        end
      end
      answer.join
    end

    def score_string(str)
      str.chars.reduce(0) do |acc, char|
        acc * 5 + COMPLETION_POINTS[char]
      end
    end

    def autocomplete
      illegal_points
      scores = (@lines - @illegal_lines)
                 .map { |line| complete_string(line) }
                 .map { |answer| score_string(answer) }
                 .sort
      scores[scores.size / 2]
    end
  end
end
