# frozen_string_literal: true

module AoC2021
  # CrabSubs implements the solutions for Day 7.
  class OctopusFlashes
    extend Forwardable
    def_instance_delegators :@board, :next_board

    def initialize(file)
      @list  = file.readlines(chomp: true).map(&:chars).map { |line| line.map(&:to_i) }
      @board = Board.new [[], *lines, []]
      # pp @board
    end

    # Encapsulates operations on a board
    class Board
      extend Forwardable
      def_instance_delegators :@board, :any?
      attr_reader :flashes

      def initialize(board, flashes = 0)
        @board   = board
        @flashes = flashes
      end

      def to_s
        # puts "Called to_s"
        @board.reduce("") do |acm, row|
          row_str = row.reduce("") { |acc, dumbo| acc + dumbo.to_s }
          acm + (row_str.empty? ? "" : "#{ row_str }\n")
        end
      end

      def next_board(steps)
        return self if steps.zero?

        increase_by_one
          .calculate_flashes
          .reset_flashes
          .next_board(steps - 1)
      end

      def increase_by_one
        Board.new(@board.map { |row| row.map { |dumbo| dumbo&.+ 1 } }, @flashes)
      end

      def calculate_flashes
        flashed_this_round = false
        @board.each_with_index do |row, y_index|
          row.each_with_index do |dumbo, x_index|
            next if dumbo&.>(20)

            next unless dumbo&.>(9)

            flashed_this_round       = true
            @board[y_index][x_index] = Float::INFINITY
            inc_neighbours(x_index, y_index)
          end
        end
        return Board.new(@board, @flashes) unless flashed_this_round

        calculate_flashes
      end

      def inc_neighbours(x, y)
        # pp @board, x, y
        ((y - 1)..(y + 1)).each do |y_idx|
          # pp y_idx
          # pp @board[y_idx]
          next if @board[y_idx].empty?

          ((x - 1)..(x + 1)).each do |x_idx|
            next unless @board[y_idx][x_idx]

            # pp x_idx
            # pp @board[y_idx][x_idx]
            @board[y_idx][x_idx] += 1
          end
        end
      end

      def reset_flashes
        Board.new(@board.map { |row| row.map { |dumbo| dumbo&.>(9) ? count_flashes : dumbo } }, @flashes)
      end

      def count_flashes
        @flashes += 1
        0
      end
    end

    def total(steps)
      @board.next_board(steps).flashes
    end

    def synchronized_at
      count = 0
      while @board.any? { |row| row.any? { |dumbo| dumbo&.positive? } }
        count += 1
        @board = @board.next_board(1)
      end
      count
    end

    private

    def lines
      # pp @list
      @list.map { |line| [nil] + line + [nil] }
    end
  end
end
