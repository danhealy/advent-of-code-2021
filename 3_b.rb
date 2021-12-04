# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      status = Status.from_raw_diagnostics(input)
      status.analyze!
      puts "Power Consumption: #{status.power_consumption}"
      puts "oxygen: #{status.oxygen}"
      puts "c02: #{status.c02}"
      puts "Life Support: #{status.life_support}"
    end
  end
end

class Status
  extend T::Sig

  sig { returns(Array) }
  attr_accessor :diagnostics

  sig { returns(Integer) }
  attr_accessor :most_common_bits

  sig { returns(Integer) }
  attr_accessor :oxygen

  sig { returns(Integer) }
  attr_accessor :c02

  sig { returns(Integer) }
  attr_accessor :mask

  class << self
    extend T::Sig

    sig { params(data_string: String).returns(Status) }
    def from_raw_diagnostics(data_string)
      Status.new(data_string.split("\n").map(&:chars))
    end
  end

  sig { params(diagnostics: Array).void }
  def initialize(diagnostics)
    @diagnostics = diagnostics
  end

  sig { returns(T.self_type) }
  def analyze!
    set_mask!
    set_mcb!
    set_oxygen_rating!
    set_c02_scrubber_rating!
    self
  end

  sig { returns(Integer) }
  def power_consumption
    most_common_bits * inverted_mcb
  end

  sig { returns(Integer) }
  def life_support
    oxygen * c02
  end

  sig { returns(Integer) }
  def inverted_mcb
    most_common_bits ^ mask
  end

  private

  sig { void }
  def set_mask!
    @mask = ('1' * T.must(diagnostics.first).length).to_i(2)
  end

  sig { void }
  def set_mcb!
    @most_common_bits = chars_to_int(
      diagnostics
        .transpose
        .map { |pos| pos.count('1') >= (diagnostics.length / 2.0).floor ? '1' : '0' }
    )
  end

  sig { void }
  def set_oxygen_rating!
    @oxygen = select_common_diagnostic(common: true)
  end

  sig { void }
  def set_c02_scrubber_rating!
    @c02 = select_common_diagnostic(common: false)
  end

  sig { params(common: T::Boolean).returns(Integer) }
  def select_common_diagnostic(common: true)
    reduced_data = T.let(diagnostics.dup, T.nilable(Array))
    mask.bit_length.times do |idx|
      reduced_data = reduce_common_data(T.must(reduced_data), idx, common)
      break if T.must(reduced_data).length <= 1
    end

    chars_to_int(T.must(T.must(reduced_data).first))
  end

  sig do
    params(
      data: Array,
      idx: Integer,
      common: T::Boolean
    ).returns(
      T.nilable(Array)
    )
  end
  def reduce_common_data(data, idx, common)
    ones, zeroes = data.partition { |diagnostic| diagnostic[idx] == '1' }
    if ones.length == zeroes.length
      common ? ones : zeroes
    else
      least, most = [ones, zeroes].sort_by(&:length)
      common ? most : least
    end
  end

  sig { params(int: Integer).returns(T::Array[String]) }
  def int_to_bit_chars(int)
    int.to_s(2).rjust(mask.bit_length, '0').chars
  end

  sig { params(chars: T::Array[String]).returns(Integer) }
  def chars_to_int(chars)
    chars.join.to_i(2)
  end
end
