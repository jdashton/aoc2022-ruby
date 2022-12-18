# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 14, we're scanning falling sand.
    class RegolithReservoir
      def self.day14
        regolith_reservoir = File.open('input/day14.txt') { |file| RegolithReservoir.new file }
        puts "Day 14, Part One: #{ regolith_reservoir.construct_board.drop_sand } units of sand come to rest before sand " \
             'starts flowing into the abyss below.'
        puts "Day 14, Part Two: #{ regolith_reservoir.construct_board.add_floor.drop_sand } units of sand come to rest."
        puts
      end

      def initialize(file)
        @lines  = file.readlines(chomp: true)
        @x_min  = @y_min = Float::INFINITY
        @x_max  = @y_max = -Float::INFINITY
        @cave   = Array.new(167) { Array.new(665) }
        @leader = ''
      end

      def construct_board
        @rocks = @lines.map do |line|
          line.split(' -> ')
              .map { |pair| pair.split(',').map(&:to_i) }
              .each_cons(2) do |(start_x, start_y), (end_x, end_y)|
            # puts "Processing #{ [[start_x, start_y], [end_x, end_y]] }"
            @cave[start_y][start_x] = '#'
            @x_min                  = [@x_min, start_x, end_x].min
            @y_min                  = [@y_min, start_y, end_y].min
            @x_max                  = [@x_max, start_x, end_x].max
            @y_max                  = [@y_max, start_y, end_y].max
            if start_y == end_y
              ([start_x, end_x].min..[start_x, end_x].max).each { |x| @cave[end_y][x] = '#' }
            else
              ([start_y, end_y].min..[start_y, end_y].max).each { |y| @cave[y][end_x] = '#' }
            end
          end
        end
        @cave[0][500] = '+'
        self
      end

      def header
        margin_width    = case @y_max
                            when (100..) then 4
                            when (10..99) then 3
                            else 2
                          end
        space_ten_width = 500 - @x_min - 1
        space_one_width = @x_max - 500 - 1
        fmt_str         = ('%*s%%d%*s%%d%*s%%d' % [margin_width, ' ', space_ten_width, ' ', space_one_width, ' ']).freeze
        [@x_min, 500, @x_max]
          .map(&:digits)
          .transpose
          .reverse
          .map { fmt_str % _1 }.join("\n") + "\n"
      end

      def render
        # pp [@x_min, @y_min, @x_max, @y_max]
        # pp @cave
        line_num_width =
          "%#{
            case @y_max
              when (100..) then 3
              when (10..99) then 2
              else 1
            end}d"
        x_range        = @x_min..@x_max
        # @cave[0][500]  = "+"

        "\n" +
          header +
          (0..@y_max).reduce([]) { |lines, y|
            lines << x_range.reduce("#{ line_num_width % y } ") do |line_str, x|
              line_str += (val = @cave.dig(y, x)) ? val : '.'
            end
          }.join("\n") + "\n"
      end

      def add_floor
        @y_max        += 2
        @x_max        = @cave[0].length
        @x_min        -= 116
        @cave[@y_max] = Array.new(@x_max + 10, '#')
        self
      end

      def drop_sand
        # pp @cave

        start_point   = [500, 0]
        @cave[0][500] = nil
        x, y          = start_point
        num_sand      = 0
        x_range       = @x_min..@x_max
        y_range       = 0..@y_max
        # result = loop do
        loop do
          # pp [x, y]
          break num_sand unless x_range.include?(x) && y_range.include?(y) && @cave[y][x].nil?

          if @cave[y + 1][(x - 1)..(x + 1)].none?(&:nil?) # This sand must come to rest
            @cave[y][x] = 'o'
            num_sand    += 1
            x, y        = start_point
            next
          end

          y += 1
          unless @cave[y][x].nil?
            x += @cave[y][x - 1].nil? ? -1 : 1
          end
        end
        # puts render
        # result
      end
    end
  end
end
