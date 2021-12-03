# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      status = Status.from_raw_diagnostics(input)
      status.analyze!
      puts "Power Consumption: #{status.power_consumption}"
    end
  end
end

class Status
  extend T::Sig

  sig { returns(T::Array[T::Array[String]]) }
  attr_accessor :diagnostics

  sig { returns(Integer) }
  attr_accessor :most_common_bits

  sig { returns(Integer) }
  attr_accessor :mask

  class << self
    extend T::Sig

    sig { params(data_string: String).returns(Status) }
    def from_raw_diagnostics(data_string)
      Status.new(data_string.split("\n").map(&:chars))
    end
  end

  sig { params(diagnostics: T::Array[T::Array[String]]).void }
  def initialize(diagnostics)
    @diagnostics = diagnostics
  end

  sig { void }
  def analyze!
    set_mask!
    @most_common_bits =
      diagnostics
      .transpose
      .map {|pos| (pos.count("1") > diagnostics.length / 2.0) ? "1" : "0" }
      .join
      .to_i(2)
  end

  sig { returns(Integer) }
  def power_consumption
    most_common_bits * (most_common_bits ^ @mask)
  end

  private

  sig { void }
  def set_mask!
    @mask = ("1"*T.must(@diagnostics.first).length).to_i(2)
  end
end
