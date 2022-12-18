# frozen_string_literal: true

module AoC2022
  module Puzzles
    # For Day 7, we're deleting files.
    class NoSpaceLeftOnDevice
      def self.day07
        dev_fs = File.open('input/day07.txt') { |file| NoSpaceLeftOnDevice.new file }
        puts "Day  7, Part One: The sum of directory sizes is #{ dev_fs.small_dir_sum }."
        puts "Day  7, Part Two: The size of the smallest directory that's large enough is #{ dev_fs.smallest_large_enough }."
        puts
      end

      def initialize(file)
        @lines = file.readlines(chomp: true).slice_before(/\A\$/).map do |slice|
          if slice[0][2..3] == 'cd'
            slice[0][5..]
          else
            parse_dir slice[1..]
          end
        end
      end

      # Returns a list of directories in this directory, and the size of the files visible in this directory.
      def parse_dir(ary)
        ary.reduce([0]) { |acc, entry| entry.start_with?('dir ') ? acc << entry[4..] : [acc[0] + entry.to_i] + acc[1..] }
      end

      def self.process(_dir_name, contents, *remainder, dir_size_list)
        size = contents[0]

        until remainder.nil? || remainder[0].nil? || remainder[0] == '..'
          subdir_size, _, remainder = process(*remainder, dir_size_list)
          size                      += subdir_size
        end

        [size, dir_size_list << size, remainder.nil? ? nil : remainder[1..]]
      end

      def self.sum_directories(list)
        process(*list, [])
      end

      def small_dir_sum
        NoSpaceLeftOnDevice.sum_directories(@lines)[1].filter { |dir| dir <= 100_000 }.sum
      end

      def smallest_large_enough
        sum_of_directories = NoSpaceLeftOnDevice.sum_directories(@lines)
        needed             = 30_000_000 - (70_000_000 - sum_of_directories[0])
        sum_of_directories[1].sort.find { |elt| elt >= needed }
      end
    end
  end
end
