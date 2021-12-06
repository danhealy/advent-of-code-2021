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
  def draw_line!(x1, y1, x2, y2)
    points_on_line(x1, y1, x2, y2).each do |(cur_x, cur_y)|
      row = T.must(grid[T.must(cur_x)])
      row[T.must(cur_y)] = T.must(row[T.must(cur_y)]) + 1
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

  private

  # rubocop:disable Naming/MethodParameterName
  sig { params(x1: Integer, y1: Integer, x2: Integer, y2: Integer).returns(T::Array[T::Array[Integer]]) }
  def points_on_line(x1, y1, x2, y2)
    cur_x = x1
    cur_y = y1
    dir_x = x1 < x2 ? 1 : -1
    dir_y = y1 < y2 ? 1 : -1
    points = [[cur_x, cur_y]]

    while (cur_x != x2) || (cur_y != y2)
      cur_x += dir_x unless cur_x == x2
      cur_y += dir_y unless cur_y == y2
      points << [cur_x, cur_y]
    end

    points
  end
  # rubocop:enable Naming/MethodParameterName
end
