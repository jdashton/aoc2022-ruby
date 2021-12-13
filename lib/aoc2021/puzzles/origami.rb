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

      def fold(fold)
        if fold.axis == :x
          Point.new(fold.value - (@x - fold.value), @y)
        else
          Point.new(@x, fold.value - (@y - fold.value))
        end
      end

      def should_fold?(fold)
        send(fold.axis) > fold.value
      end
    end

    # Encapsulates operations on a fold instruction
    class Fold
      attr_reader :axis, :value

      def initialize(axis, value)
        @axis  = axis.to_sym
        @value = value.to_i
      end
    end

    def initialize(file)
      @points = Set[]
      @folds  = []
      file.readlines(chomp: true).each do |line|
        next if line.empty?

        if line.start_with? "fold along"
          @folds << Fold.new(*line[11..].split("="))
        else
          @points << Point.new(*line.split(",").map(&:to_i))
        end
      end
      # pp self
    end

    def first_fold = fold([@folds.first])

    def visible_dots = @points.size

    def final_shape
      fold(@folds)
      shape
    end

    private

    def fold(fold_list)
      fold_list.each do |fold|
        @points = @points.reduce(Set.new) { |acc, point| acc << (point.should_fold?(fold) ? point.fold(fold) : point) }
      end
      self
    end

    def shape
      to_hash
      string = ""
      (@y_vals.min..@y_vals.max).each do |y_index|
        (@x_vals.min..@x_vals.max).each do |x_index|
          string += @hash[[x_index, y_index]] || " "
        end
        string += "\n"
      end
      string
    end

    def to_hash
      @x_vals = Set.new
      @y_vals = Set.new
      @hash   = @points.reduce({}) do |acc, point|
        @x_vals << point.x
        @y_vals << point.y
        acc.merge [point.x, point.y] => "#"
      end
    end
  end
end
