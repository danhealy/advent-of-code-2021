# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      instructions = Instruction.parse_raw(input)
      puts "Multiplied Position & Depth: #{Submarine.new.follow_instructions(instructions).dead_reckoning}"
    end
  end
end

class Instruction
  extend T::Sig
  attr_accessor :direction, :units

  class << self
    extend T::Sig

    sig { params(data_string: String).returns(T::Array[Instruction]) }
    def parse_raw(data_string)
      data_string.split("\n").map(&:split).map do |(raw_direction, raw_units)|
        Instruction.new(raw_direction.to_sym, raw_units.to_i)
      end
    end
  end

  sig { params(direction: Symbol, units: Integer).void }
  def initialize(direction, units)
    @direction = direction
    @units = units
  end
end

class Submarine
  extend T::Sig

  AXIS = {
    forward: :position,
    up: :depth,
    down: :depth
  }.freeze

  DIRECTIONS = {
    forward: 1,
    up: -1,
    down: 1
  }.freeze

  attr_accessor :depth, :position

  sig { params(depth: Integer, position: Integer).void }
  def initialize(depth: 0, position: 0)
    @depth = depth
    @position = position
  end

  sig { params(instruction: Instruction).returns(T.self_type) }
  def follow_instruction(instruction)
    magnitude = DIRECTIONS[instruction.direction] * instruction.units

    case AXIS[instruction.direction]
    when :position
      @position += magnitude
    else # depth
      @depth += magnitude
    end
    self
  end

  sig { params(instructions: T::Array[Instruction]).returns(T.self_type) }
  def follow_instructions(instructions)
    instructions.each { |instruction| follow_instruction(instruction) }
    self
  end

  sig { returns(Integer) }
  def dead_reckoning
    @depth * @position
  end
end
