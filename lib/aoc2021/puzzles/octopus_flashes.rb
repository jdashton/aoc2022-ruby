# frozen_string_literal: true

module AoC2021
  # OctopusFlashes implements the solutions for Day 11.
  class OctopusFlashes
    extend Forwardable
    def_instance_delegators :@board, :next_board, :to_str, :synchronized_at

    # Encapsulates operations on a board
    class Board
      extend Forwardable
      def_instance_delegators :@board, :none?, :map
      def_instance_delegators "self.class", :bounded_range
      attr_reader :flashes

      # Encapsulates operations on one row of a board
      class Row
        extend Forwardable
        def_instance_delegators :@row, :map, :each_with_index, :[], :[]=, :empty?, :reduce, :any?, :size

        def initialize(row)
          @row = row
        end

        def to_str
          return "" if @row.empty?

          # `nil.to_s` returns an empty string--very convenient.
          "#{ @row.map(&:to_s).reduce(&:+) }\n"
        end

        def +(other)
          to_str + other
        end

        # Find if any cells are non-zero.
        def any_positive?
          @row.reject(&:nil?).any?(&:positive?)
        end

        def increase_row_by_one
          @row.map { |dumbo| dumbo&.+ 1 }
        end

        def calculate_row_flashes(flashed_this_round, board, y_index)
          @row.each_with_index.reduce(flashed_this_round) do |acc, (dumbo, x_index)|
            next acc if dumbo&.>(20) || !dumbo&.>(9)

            board.do_flash x_index, y_index
            true
          end
        end

        def reset_row_flashes(board)
          @row.map { |dumbo| dumbo&.>(9) ? board.count_flashes : dumbo }
        end
      end

      def initialize(board, flashes = 0)
        @board   = board.map { |row| Row.new row }
        @flashes = flashes
      end

      def to_str
        @board.reduce(&:+)
      end

      def to_s
        to_str
      end

      def increase_by_one
        Board.new(@board.map(&:increase_row_by_one), @flashes)
      end

      def calculate_flashes
        flashed_this_round = @board.each_with_index.reduce(false) do |acc, (row, index)|
          row.calculate_row_flashes(acc, self, index)
        end
        return Board.new(@board, @flashes) unless flashed_this_round

        calculate_flashes
      end

      def inc_neighbours(x_idx, y_idx)
        bounded_range(x_idx, @board[1].size).product(bounded_range(y_idx, @board.size)) { |x, y| @board[y][x] += 1 }
      end

      def reset_flashes
        Board.new(@board.map { |row| row.reset_row_flashes(self) }, @flashes)
      end

      def count_flashes
        @flashes += 1
        0
      end

      def next_board(steps)
        return self if steps.zero?

        increase_by_one
          .calculate_flashes
          .reset_flashes
          .next_board(steps - 1)
      end

      def synchronized_at
        (0..).reduce do |acc, _|
          break acc if @board.none?(&:any_positive?)

          @board = next_board(1)

          acc + 1
        end
      end

      def do_flash(x_index, y_index)
        @board[y_index][x_index] = Float::INFINITY
        inc_neighbours(x_index, y_index)
      end

      def self.bounded_range(x, size)
        ([x - 1, 1].max..[x + 1, size - 2].min).to_a
      end
    end

    def initialize(file)
      @list  = file.readlines(chomp: true).map(&:chars).map { |line| line.map(&:to_i) }
      @board = Board.new [[], *lines, []]
    end

    def total(steps) = @board.next_board(steps).flashes

    private

    def lines = @list.map { |line| [nil] + line + [nil] }
  end
end
