# frozen_string_literal: true

require "forwardable"

module AoC2021
  # Image Enhancement for Day 20
  class TrenchMap
    # extend Forwardable
    # def_instance_delegators "self.class", :y_step, :gauss

    # Encapsulates operations on an image to be refined.
    class Image
      def initialize(lines)
        @lines = lines.map { _1.tr(".#", "01") }.map(&:chars).map { _1.map(&:to_i) }
        @lines = extend_image(0)
        # puts "Initial image"
        # puts "#{ self.to_s }"
        # pp @lines
        # puts

        @internal_iteration = 0
      end

      def process(algorithm, iterations_remaining)
        return self if iterations_remaining.zero?

        @internal_iteration += 1
        new_lines           = extend_image(@internal_iteration.odd? ? 0 : algorithm[0][0][0][0][0][0][0][0][0])
        # print "\n In iteration #{ @internal_iteration }: "
        # pp new_lines

        @lines = new_lines.each_index.each_cons(3).map do |h, i, j|
          new_lines[h].each_cons(3).zip(new_lines[i].each_cons(3), new_lines[j].each_cons(3)).map do |b|
            algorithm[b[0][0]][b[0][1]][b[0][2]][b[1][0]][b[1][1]][b[1][2]][b[2][0]][b[2][1]][b[2][2]]
          end
        end

        @lines = extend_image(@internal_iteration.odd? ? algorithm[0][0][0][0][0][0][0][0][0] : 0)

        # puts "Finished with iteration #{ @internal_iteration }"
        # puts "#{ self.to_s }"
        # puts

        process(algorithm, iterations_remaining - 1)
      end

      def to_s
        # print "Printing "
        # pp @lines[1..-2].map { _1[1..-2] }
        "#{ @lines[1..-2].map { _1[1..-2] }.map { _1.map(&:to_s) }.map(&:join).join("\n").tr("01", ".#") }\n"
      end

      private

      def extend_image(border_bit)
        new_length = @lines[0].length + 2
        border_row = Array.new(new_length, border_bit)
        [border_row, *@lines.map { [border_bit, *_1, border_bit] }, border_row]
      end
    end

    def self.day20
      trench_map = File.open("input/day20a.txt") { |file| TrenchMap.new file }
      puts "Day 20, part A: #{ trench_map.lit_pixels_after(2) } pixels are lit in the resulting image."
      # puts "Day 20, part B: #{ trench_map.lit_pixels_after(48) } pixels are lit in the resulting image."
      puts
    end

    def make_algo_array
      prog   = @lines[0].tr(".#", "01").each_char
      output = Array.new(2) { Array.new(2) { Array.new(2) { Array.new(2) { Array.new(2) { Array.new(2) { Array.new(2) { Array.new(2) { Array.new(2) {} } } } } } } } }
      (0..1).map do |idx0|
        (0..1).map do |idx1|
          (0..1).map do |idx2|
            (0..1).map do |idx3|
              (0..1).map do |idx4|
                (0..1).map do |idx5|
                  (0..1).map do |idx6|
                    (0..1).map do |idx7|
                      (0..1).map do |idx8|
                        output[idx0][idx1][idx2][idx3][idx4][idx5][idx6][idx7][idx8] = prog.next.to_i
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    attr_reader :algorithm, :lines

    def initialize(file)
      @lines        = file.readlines(chomp: true)
      @algorithm    = make_algo_array
      @input_image  = Image.new(@lines[2..])
      @output_image = @input_image
    end

    def lit_pixels_after(iterations)
      # { 0 => 10, 1 => 24, 2 => 35 }[iterations]
      @output_image.process(@algorithm, iterations).to_s.chars.tally["#"] || 0
    end

    def enhance(iterations)
      return @output_image.process(@algorithm, iterations).to_s
    end
  end
end
