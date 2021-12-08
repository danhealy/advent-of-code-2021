# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      seg = SevenSeg.new
      seg.seed(input)
      puts "Output: #{seg.analyze}"
    end
  end
end

class SegmentMap
  extend T::Sig

  ALL_LETTERS = ('a'..'g').to_a

  sig { returns(T::Array[String]) }
  attr_accessor :a

  sig { returns(T::Array[String]) }
  attr_accessor :b

  sig { returns(T::Array[String]) }
  attr_accessor :c

  sig { returns(T::Array[String]) }
  attr_accessor :d

  sig { returns(T::Array[String]) }
  attr_accessor :e

  sig { returns(T::Array[String]) }
  attr_accessor :f

  sig { returns(T::Array[String]) }
  attr_accessor :g

  sig { returns(T::Hash[T::Array[String], Integer]) }
  attr_accessor :mapping

  # 2-charater pattern is 1 ("cf"), 3-chars is 1 + "a", 4-chars is 1 + "bd"
  # All of those plus "g" is 9. (a 6-char pattern)
  # Remaining letter is e.
  # Remaining 6-char patterns are 0 and 6, difference is "d"/"c"
  sig { params(patterns: T::Array[String]).returns(T.self_type) }
  def segments_from_patterns(patterns)
    sorted_patterns = sort_patterns(patterns)

    one   = T.must(T.must(sorted_patterns[2]).first)
    seven = T.must(T.must(sorted_patterns[3]).first)
    four  = T.must(T.must(sorted_patterns[4]).first)

    @a = seven - one

    @g = T.must(sorted_patterns[6])
          .map { |nines| (nines - (@a | four)) }
          .select { |nines| nines.length == 1 }
          .flatten

    nine = (seven | four | @g).sort

    zero_six = (T.must(sorted_patterns[6]) - [nine])

    c_or_d = ALL_LETTERS - zero_six[0]
    the_other_one = ALL_LETTERS - zero_six[1]

    @c = c_or_d
    @d = the_other_one

    @c, @d = @d, @c if (one & c_or_d).none?

    @e = ALL_LETTERS - nine
    @f = one - @c
    @b = four - (one | @d)

    self
  end

  # rubocop:disable Layout/HashAlignment
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/ParameterLists
  # rubocop:disable Naming/MethodParameterName
  def build_mapping!
    @mapping = {
      (a | b | c | e | f | g)     => 0,
      (c | f)                     => 1,
      (a | c | d | e | g)         => 2,
      (a | c | d | f | g)         => 3,
      (b | c | d | f)             => 4,
      (a | b | d | f | g)         => 5,
      (a | b | d | e | f | g)     => 6,
      (a | c | f)                 => 7,
      (a | b | c | d | e | f | g) => 8,
      (a | b | c | d | f | g)     => 9
    }.transform_keys(&:sort)
  end
  # rubocop:enable Layout/HashAlignment
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/ParameterLists
  # rubocop:enable Naming/MethodParameterName

  private

  sig { params(patterns: T::Array[String]).returns(T::Hash[Integer, T::Array[T::Array[String]]]) }
  def sort_patterns(patterns)
    patterns.map(&:chars).map(&:sort).group_by(&:length)
  end
end

class SevenSeg
  extend T::Sig

  sig { returns(T::Array[T::Array[String]]) }
  attr_accessor :output

  sig { void }
  def initialize
    @output = []
  end

  sig { params(input: String).returns(T.self_type) }
  def seed(input)
    input.split("\n").map { |line| line.split(' | ').map(&:split) }.each do |line|
      new_output = analyze_display(T.must(line[0]), T.must(line[1]))
      @output << new_output
    end
    self
  end

  sig { params(patterns: T::Array[String], signals: T::Array[String]).returns(T::Array[Integer]) }
  def analyze_display(patterns, signals)
    segs = SegmentMap.new.segments_from_patterns(patterns)
    segs.build_mapping!
    sorted_output = signals.map(&:chars).map(&:sort)
    sorted_output.map { |outputs| T.must(segs.mapping[outputs]) }
  end

  sig { returns(Integer) }
  def analyze
    totals = @output.flatten.tally
    totals[1] + totals[4] + totals[7] + totals[8]
  end
end
