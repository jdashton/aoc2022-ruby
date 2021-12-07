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
      @list       = file.readline(chomp: true).split(/,/).map(&:to_i)
      h_positions = @list.tally
      @minmax     = Range.new(*h_positions.keys.minmax)
      @pos_freqs  = h_positions.to_a.map { |pos, freq| PosFreq.new(pos, freq) }
      @mean       = @list.sum(0.0) / @list.size
    end

    def move_loop(delta_method) = @minmax.map { |num| reduce_deltas delta_method, num }.min

    def minimal_move
      # Narrowing @minmax is an after-the-fact optimization to save time on runs for the remaining days.
      @minmax = (@mean - 122).to_i..(@mean + 1).to_i
      move_loop(:delta)
    end

    def minimal_move_revised
      # Narrowing @minmax is an after-the-fact optimization to save time on runs for the remaining days.
      @minmax = (@mean - 1).to_i..(@mean + 1).to_i
      move_loop(:delta_revised)
    end

    private

    def reduce_deltas(delta_method, num)
      @pos_freqs.reduce(0) { |acc, pos_freq| acc + pos_freq.send(delta_method, num) }
    end
  end
end
