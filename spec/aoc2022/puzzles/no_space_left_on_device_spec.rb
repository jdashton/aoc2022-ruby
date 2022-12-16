# frozen_string_literal: true

RSpec.describe AoC2022::Puzzles::NoSpaceLeftOnDevice do
  context 'with provided test data' do
    subject(:no_space_left_on_device) { described_class.new StringIO.new(<<~DATA) }
      $ cd /
      $ ls
      dir a
      14848514 b.txt
      8504156 c.dat
      dir d
      $ cd a
      $ ls
      dir e
      29116 f
      2557 g
      62596 h.lst
      $ cd e
      $ ls
      584 i
      $ cd ..
      $ cd ..
      $ cd d
      $ ls
      4060174 j
      8033020 d.log
      5626152 d.ext
      7214296 k
    DATA

    it 'finds 95,437 as the sum of small directories' do
      expect(no_space_left_on_device.small_dir_sum).to eq 95_437
    end

    it 'finds 24,933,642 as the size of the smallest large enough directory' do
      expect(no_space_left_on_device.smallest_large_enough).to eq 24_933_642
    end
  end

  context 'with actual input data' do
    subject(:no_space_left_on_device) { File.open('input/day07.txt') { |file| described_class.new file } }

    it 'finds 1,648,397 as the sum of small directories' do
      expect(no_space_left_on_device.small_dir_sum).to eq 1_648_397
    end

    # 41,735,494 is too high
    it 'finds 1,815,525 as the size of the smallest large enough directory' do
      expect(no_space_left_on_device.smallest_large_enough).to eq 1_815_525
    end
  end
end
