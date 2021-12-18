# frozen_string_literal: true

module AoC2021
  # Chitons implements the solutions for Day 16.
  class PacketDecoder
    def self.day16
      packet_decoder = File.open("input/day16a.txt") { |file| PacketDecoder.new file }
      puts "Day 16, part A: #{ packet_decoder.sum_version_numbers } when you add up the version numbers in all packets"
      puts "Day 16, part B: #{ packet_decoder.execute } is the final output"
      puts
    end

    # Encapsulates operations on a packet.
    class Packet
      attr_reader :content, :version, :type

      def initialize(binary_string)
        @content = binary_string
        @version = @content[0..2].to_i(2)
        @type    = @content[3..5].to_i(2)
      end

      def ==(other)
        @content == other.content
      end

      OPS = {
        0 => :sum,
        1 => :product,
        2 => :minimum,
        3 => :maximum,
        5 => :greater_than,
        6 => :less_than,
        7 => :equal_to
      }.freeze

      def read_packet(content = @content)
        # puts "read_packet( #{ content } )"
        remnant = ""
        version = content[0..2].to_i(2)
        type    = content[3..5].to_i(2)
        packet  = case type
                    when 4
                      num, remnant = read_num(content)
                      { ver: version, type: :number, val: num }
                    else
                      # pp self
                      length_type_id = content[6].to_i
                      case length_type_id
                        when 0
                          num_bits         = content[7, 15].to_i(2)
                          subpacket_string = content[22, num_bits]
                          subpackets       = []
                          while subpacket_string.length.positive?
                            packet, subpacket_string = read_packet(subpacket_string)
                            subpackets << packet
                          end
                          remnant          = content[(22 + num_bits)..]
                        else
                          num_subpackets   = content[7, 11].to_i(2)
                          subpacket_string = content[18..]
                          subpackets       = []
                          num_subpackets.times do
                            packet, subpacket_string = read_packet(subpacket_string)
                            subpackets << packet
                          end
                          remnant = subpacket_string
                      end
                      { ver: version, type: OPS[type], val: subpackets }
                  end
        [packet, remnant]
      end

      def read_num(string)
        ptr = 6
        buf = String.new
        loop do
          buf += string[ptr + 1..ptr + 4]
          break if string[ptr] == "0"

          ptr += 5
        end
        [buf.to_i(2), string[(ptr + 5)..]]
      end
    end

    def initialize(file)
      @content    = file.readline(chomp: true)
      @top_packet = make_packet(@content).read_packet[0]
    end

    # [ver: 7, type: :operator3, val: [
    #             [ver: 2, type: :number, val: 1],
    #             [ver: 4, type: :number, val: 2],
    #             [ver: 1, type: :number, val: 3]
    #           ]]
    # subject.sum_version_numbers(subject.make_packet("A0016C880162017C3686B18A3D4780").read_packet[0])
    def sum_version_numbers(packet_tree = @top_packet)
      if packet_tree[:type] == :number
        packet_tree[:ver]
      else
        packet_tree[:ver] + packet_tree[:val].reduce(0) { |acc, entry| acc + sum_version_numbers(entry) }
      end
    end

    def to_binary_string(hex_string)
      short_binary = hex_string.to_i(16).to_s(2)
      "#{ "0" * ((hex_string.length * 4) - short_binary.length) }#{ short_binary }"
    end

    def make_packet(hex_string) = Packet.new(to_binary_string(hex_string))

    def execute(packet_tree = @top_packet)
      # pp packet_tree
      packet_tree[:val] = packet_tree[:val].map do |node|
        next node if node[:type] == :number

        { ver: node[:ver], type: :number, val: execute(node) }
      end
      case packet_tree[:type]
        when :sum
          packet_tree[:val].reduce(0) { |acc, packet| acc + packet[:val] }
        when :product
          packet_tree[:val].reduce(1) { |acc, packet| acc * packet[:val] }
        when :minimum
          packet_tree[:val].map { |hash| hash[:val] }.min
        when :maximum
          packet_tree[:val].map { |hash| hash[:val] }.max
        when :less_than
          packet_tree[:val][0][:val] < packet_tree[:val][1][:val] ? 1 : 0
        when :greater_than
          packet_tree[:val][0][:val] > packet_tree[:val][1][:val] ? 1 : 0
        when :equal_to
          packet_tree[:val][0][:val] == packet_tree[:val][1][:val] ? 1 : 0
      end
    end
  end
end
