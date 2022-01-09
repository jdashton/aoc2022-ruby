# frozen_string_literal: true

module AoC2021
  # This priority queue is based on a sparse array with sets in each
  # populated bucket.
  class PriorityQueue
    def initialize
      @queue    = []
      @low_item = Float::INFINITY
    end

    def next
      return nil if @low_item == Float::INFINITY

      while @low_item < @queue.length
        @queue[@low_item] = nil if @queue[@low_item] && @queue[@low_item].empty?
        next @low_item += 1 unless @queue[@low_item]

        item = @queue[@low_item].first
        @queue[@low_item].delete(item)
        return item
      end
    end

    # `item` must respond to the `score` method call.
    def <<(item)
      @queue[priority = item.score] ||= Set[]
      @queue[priority] << item
      @low_item = [@low_item, priority].min
    end

    def concat(*others)
      others.each do |oth|
        oth.each { self << _1 }
      end
    end
  end
end
