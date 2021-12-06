# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      map = Map.new
      map.draw_lines_from_raw!(input)
      puts "Overlaps: #{map.count_overlaps}"
    end
  end
end

class Map
  extend T::Sig

  sig { returns(T::Array[T::Array[Integer]]) }
  attr_accessor :grid

  sig { void }
  def initialize
    @grid = Array.new(1000) { Array.new(1000, 0) }
  end

  # rubocop:disable Naming/MethodParameterName
  sig { params(x1: Integer, y1: Integer, x2: Integer, y2: Integer).void }
  def draw_line!(x1, y1, x2, y2)
    return unless x1 == x2 || y1 == y2

    sorted_x1, sorted_x2 = [x1, x2].sort
    sorted_y1, sorted_y2 = [y1, y2].sort

    (sorted_x1..sorted_x2).each do |x|
      row = T.must(grid[x])
      (sorted_y1..sorted_y2).each do |y|
        row[y] = T.must(row[y]) + 1
      end
    end
  end
  # rubocop:enable Naming/MethodParameterName

  sig { params(points_string: String).void }
  def draw_lines_from_raw!(points_string)
    points_string.each_line do |line|
      T.unsafe(self).draw_line!(*line.chomp.gsub(' -> ', ',').split(',').map(&:to_i))
    end
  end

  sig { returns(Integer) }
  def count_overlaps
    grid.flatten.reject { |elem| elem < 2 }.length
  end
end
