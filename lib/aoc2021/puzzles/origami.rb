# frozen_string_literal: true

module AoC2021
  # Origami implements the solutions for Day 12.
  class Origami
    # extend Forwardable
    # def_instance_delegators :@successes, :size

    # Encapsulates operations on a point
    class Point
      attr_reader :x, :y

      def initialize(x, y)
        @x = x
        @y = y
      end

      def to_str = "(#{ x }, #{ y })"

      def to_s = to_str

      def inspect = "x: #{ x }, y: #{ y }"

      def ==(other)
        @x == other.x && @y == other.y
      end

      def eql?(other)
        self == other
      end

      def hash = [@x, @y].hash

      def to_ary = [@x, @y]
    end

    # Encapsulates operations on a fold instruction
    class Fold
      attr_reader :axis, :value

      def initialize(axis, value)
        @axis  = axis.to_sym
        @value = value.to_i
      end

      def should_fold?(point)
        point.send(@axis) > @value
      end

      def fold_point(point)
        x = point.x
        y = point.y
        if @axis == :x
          Point.new(@value - (x - @value), y)
        else
          Point.new(x, @value - (y - @value))
        end
      end
    end

    def initialize(file)
      @points = Set.new
      @x_vals = Set.new
      @y_vals = Set.new
      @folds  = []
      parse_file(file)
    end

    def first_fold = fold([@folds.first])

    def visible_dots = @points.size

    def final_shape
      fold(@folds)
      shape
    end

    private

    def parse_file(file)
      file.readlines(chomp: true).each do |line|
        case line
          in ""
            next
          in /fold along /
            @folds << Fold.new(*line[11..].split("="))
          else
            @points << Point.new(*line.split(",").map(&:to_i))
        end
      end
    end

    def fold(fold_list)
      fold_list.each(&method(:do_fold))
      self
    end

    def do_fold(fold)
      @points = @points.reduce(Set[]) { |acc, point| acc << (fold.should_fold?(point) ? fold.fold_point(point) : point) }
    end

    def shape
      points_hash = convert_to_hash
      x_max       = x_range.end
      y_range.to_a.product(x_range.to_a).reduce("") do |string, coord_pair|
        string + (points_hash[coord_pair.reverse] || " ") + (coord_pair[1] == x_max ? "\n" : "")
      end
    end

    def y_range = Range.new(*@y_vals.to_a.sort.minmax)

    def x_range = Range.new(*@x_vals.to_a.sort.minmax)

    def convert_to_hash
      @points.reduce({}) do |acc, (x, y)|
        @x_vals << x
        @y_vals << y
        acc.merge [x, y] => "#"
      end
      # [new_hash, Range.new(*x_vals.to_a.sort.minmax), Range.new(*y_vals.to_a.sort.minmax)]
    end
  end
end
