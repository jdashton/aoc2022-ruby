# frozen_string_literal: true

module AoC2021
  # Polymers implements the solutions for Day 14.
  class Polymers
    extend Forwardable
    def_instance_delegators "self.class", :score, :string_to_pairs, :difference, :add_vals

    def self.day14
      polymers = File.open("input/day14a.txt") { |file| Polymers.new file }
      puts "Day 14, part A: #{ polymers.process(10) } difference between the most and least common elements after 10 iterations"
      puts "Day 14, part B: #{ polymers.process(40) } difference between the most and least common elements after 40 iterations"
      puts
    end

    def initialize(file)
      @lines        = file.readlines(chomp: true)
      @template     = @lines[0]
      @instructions = {}
      @lines[2..].each do |line|
        pair, new_p         = line.split(" -> ")
        @instructions[pair] = new_p
      end
    end

    def process(iterations)
      difference(score(@template[0], iterate(iterations, string_to_pairs(@template))))
    end

    # expect(subject.iterate(1, { "NN" => 1, "NC" => 1, "CB" => 1 }))
    #           .to eq({ "NC" => 1, "CN" => 1, "NB" => 1, "BC" => 1, "CH" => 1, "HB" => 1 })
    def iterate(reps, input)
      return input if reps.zero?

      iterate(reps - 1, input.reduce(Hash.new(0), &method(:new_pairs)))
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
      merge_score(hash_of_pairs.reduce(Hash.new(0), &method(:merge_score)), [first_letter, 1])
    end

    def self.merge_score(acc, (letter, freq))
      acc.merge({ letter[-1] => freq }, &method(:add_vals))
    end

    def self.add_vals(_, new, old)
      old + new
    end

    private

    def new_pairs(acc, (pair, freq))
      new_polymer = @instructions[pair]
      acc.merge({ pair[0] + new_polymer => freq, new_polymer + pair[1] => freq }, &method(:add_vals))
    end
  end
end
