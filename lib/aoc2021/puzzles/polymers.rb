# frozen_string_literal: true

module AoC2021
  # Origami implements the solutions for Day 13.
  class Polymers
    extend Forwardable
    def_instance_delegators "self.class", :score, :string_to_pairs, :difference

    def initialize(file)
      @lines        = file.readlines(chomp: true)
      @template     = @lines.shift
      @instructions = {}
      @lines.shift # dump an empty line
      @lines.each do |line|
        pair, new_p         = line.split(" -> ")
        @instructions[pair] = new_p
      end
    end

    def insert(num)
      (1..num).reduce(@template) do |current, _|
        current.chars
               .each_cons(2)
               .map(&:join)
               .reduce(current[0]) do |acc, pair|
          acc + (@instructions[pair])
        end
      end
    end

    def process(iterations)
      difference(score(@template[0], iterate(iterations, string_to_pairs(@template))))
    end

    # expect(subject.iterate(1, { "NN" => 1, "NC" => 1, "CB" => 1 }))
    #           .to eq({ "NC" => 1, "CN" => 1, "NB" => 1, "BC" => 1, "CH" => 1, "HB" => 1 })
    def iterate(reps, input)
      return input if reps.zero?

      iterate(reps - 1,
              input.reduce(Hash.new(0)) do |acc, (pair, freq)|
                new_polymer = @instructions[pair]
                acc
                  .merge({ pair[0] + new_polymer => freq }) { |_, old, new| old + new }
                  .merge({ new_polymer + pair[1] => freq }) { |_, old, new| old + new }
              end)
    end

    def self.difference(input)
      min, max = input.values.minmax
      max - min
    end

    def self.string_to_pairs(input)
      input.chars.each_cons(2).map(&:join).tally
    end

    # expect(subject.score("N", { "NN" => 1, "NC" => 1, "CB" => 1 })).to eq({ "N" => 2, "C" => 1, "B" => 1 })
    def self.score(first_letter, hash_of_pairs)
      hash_of_pairs.reduce(Hash.new(0)) { |acc, (pair, freq)|
        acc.merge({ pair[-1] => freq }) { |_, old, new| old + new }
      }.merge({ first_letter => 1 }) { |_, old, new| old + new }
    end
  end
end
