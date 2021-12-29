

module AoC2021
  class PriorityQueue
    def initialize
      @queue = []
      @low_item = Float::INFINITY
    end

    def next
      return nil if @low_item == Float::INFINITY

      while @low_item < @queue.length
        @queue[@low_item] = nil if @queue[@low_item]&.empty?
        next @low_item += 1 unless @queue[@low_item]

        item = @queue[@low_item].first
        @queue[@low_item].delete(item)
        return item
      end
    end

    def <<(item)
      weight = item[1]
      @queue[weight] ||= Set[]
      @queue[weight] << item
      @low_item = [@low_item, weight].min
    end

    def +(collection)
      collection.each { |item| self << item }
      self
    end
  end
end
