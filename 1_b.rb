# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      sonar = Sonar.from_raw(input)
      puts "Depth Increases: #{sonar.count_depth_increases}"
      puts "Window Increases: #{sonar.count_window_increases}"
    end
  end
end

class Sonar
  extend T::Sig
  attr_accessor :measurements
  attr_accessor :measurement_windows

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

      sonar.generate_measurement_windows!

      sonar
    end

    sig { params(data_string: String).returns(Sonar) }
    def from_raw(data_string)
      from_measurements(parse_raw_measurements(data_string))
    end
  end

  sig { void }
  def generate_measurement_windows!
    @measurement_windows = measurements.each_cons(3).map do |tuple|
      MeasurementWindow.new(tuple)
    end
  end

  sig { returns(Integer) }
  def count_depth_increases
    measurements.each_cons(2).inject(0) do |acc, (a, b)|
      acc += 1 if a.depth < b.depth
      acc
    end
  end

  sig { returns(Integer) }
  def count_window_increases
    measurement_windows.each_cons(2).inject(0) do |acc, (a, b)|
      acc += 1 if a.total_depth < b.total_depth
      acc
    end
  end
end

class MeasurementWindow
  extend T::Sig
  attr_accessor :measurements

  sig { params(measurements: T::Array[Measurement]).void }
  def initialize(measurements)
    @measurements = measurements
  end

  sig { returns(Integer) }
  def total_depth
    measurements.map(&:depth).sum
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
