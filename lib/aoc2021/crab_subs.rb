# frozen_string_literal: true

# Encapsulates operations on a Position/Frequency pair
class PosFreq
  attr_reader :freq

  def initialize(pos, freq)
    @pos  = pos
    @freq = freq
  end

  def delta(num)
    (num - @pos).abs * @freq
  end

  def delta_revised(num)
    distance = (num - @pos).abs
    distance * (distance + 1) / 2 * @freq
  end
end

module AoC2021
  # CrabSubs implements the solutions for Day 7.
  class CrabSubs
    def initialize(file)
      h_positions = file.readline(chomp: true).split(/,/).map(&:to_i).tally
      @pos_freqs  = h_positions.to_a.map { |pos, freq| PosFreq.new(pos, freq) }
      @minmax     = Range.new(*h_positions.keys.minmax)
    end

    def move_loop(delta_method) = @minmax.map { |num| reduce_deltas delta_method, num }.min

    def minimal_move = move_loop(:delta)

    def minimal_move_revised = move_loop(:delta_revised)

    private

    def reduce_deltas(delta_method, num)
      @pos_freqs.reduce(0) { |acc, pos_freq| acc + pos_freq.send(delta_method, num) }
    end
  end
end
