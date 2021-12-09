# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      map = Map.new
      map.seed(input)
      puts "Output: #{map.find_low_points}"
    end
  end
end

class Map
  extend T::Sig

  sig { returns(T::Array[T::Array[Integer]]) }
  attr_accessor :map

  sig { returns(T::Array[Integer]) }
  attr_accessor :low_points

  sig { void }
  def initialize
    @map = [[0]]
    @low_points = []
  end

  sig { params(input: String).returns(T.self_type) }
  def seed(input)
    @map = input.split("\n").map { |line| line.chars.map(&:to_i) }

    self
  end

  sig { returns(Integer) }
  def find_low_points
    @low_points = []
    @map.each_with_index do |row, x|
      row.each_with_index do |cur, y|
        next if row[y - 1] && row[y - 1] <= cur
        next if row[y + 1] && row[y + 1] <= cur

        next if @map[x - 1] && @map[x - 1][y] <= cur
        next if @map[x + 1] && @map[x + 1][y] <= cur

        low_points << cur
      end
    end

    @low_points.sum + @low_points.length
  end
end
