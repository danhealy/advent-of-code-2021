# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      crabs = CrabAlignment.new
      crabs.seed(input.split(',').map(&:to_i))
      puts "Fuel Consumption: #{crabs.analyze!}"
    end
  end
end

class CrabAlignment
  extend T::Sig

  sig { returns(Hash) }
  attr_accessor :crabs

  sig { returns(Integer) }
  attr_accessor :min_x

  sig { returns(Integer) }
  attr_accessor :max_x

  sig { returns(Integer) }
  attr_accessor :alignment

  sig { void }
  def initialize
    @crabs = Hash.new(0)
  end

  sig { params(new_crabs: T::Array[Integer]).returns(T.self_type) }
  def seed(new_crabs)
    new_crabs.each do |crab|
      @crabs[crab] += 1
    end

    @min_x, @max_x = crabs.keys.sort.minmax

    self
  end

  sig { returns(Integer) }
  def analyze!
    fuel_consumption = (min_x..max_x).each_with_object({}) do |position, results|
      results[position] = fuel_consumption_at(position)
      print '.'
      break results if results[position - 1] && results[position] > results[position - 1]
    end
    print "\n"
    @alignment = fuel_consumption.min_by(&:last).last
  end

  private

  sig { params(position: Integer).returns(Integer) }
  def fuel_consumption_at(position)
    crabs.inject(0) do |acc, (cur_key, cur_val)|
      acc + (cur_val * (0..(cur_key - position).abs).inject(:+))
    end
  end
end
