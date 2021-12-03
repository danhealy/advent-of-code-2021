# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      sonar = Sonar.from_raw(input)
      puts "Depth Increases: #{sonar.count_depth_increases}"
    end
  end
end

class Sonar
  extend T::Sig
  attr_accessor :measurements

  class << self
    extend T::Sig

    sig { params(data_string: String).returns(T::Array[Integer]) }
    def parse_raw_measurements(data_string)
      data_string.split.map(&:to_i)
    end

    sig { params(depths: T::Array[Integer]).returns(Sonar) }
    def from_measurements(depths)
      sonar = new

      sonar.measurements = depths.map do |depth|
        Measurement.new(depth)
      end

      sonar
    end

    sig { params(data_string: String).returns(Sonar) }
    def from_raw(data_string)
      from_measurements(parse_raw_measurements(data_string))
    end
  end


  sig { returns(Integer) }
  def count_depth_increases
    measurements.each_cons(2).inject(0) do |acc, (a, b)|
      acc += 1 if a.depth < b.depth
      acc
    end
  end
end

class Measurement
  extend T::Sig
  attr_accessor :depth

  sig { params(depth: Integer).void }
  def initialize(depth)
    @depth = depth
  end
end
