# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      map = Map.new
      map.seed(input)
      puts "Output: #{map.analyze}"
    end
  end
end

class Map
  extend T::Sig

  sig { returns(T::Array[T::Array[Integer]]) }
  attr_accessor :map

  sig { returns(T::Array[T::Array[Integer]]) }
  attr_accessor :basins

  sig { returns(T::Array[Integer]) }
  attr_accessor :low_points

  sig { returns(Integer) }
  attr_accessor :max_x

  sig { returns(Integer) }
  attr_accessor :max_y

  sig { void }
  def initialize
    @map = [[0]]
    @low_points = []
    @basins = []
  end

  sig { params(input: String).returns(T.self_type) }
  def seed(input)
    @map = input.split("\n").map { |line| line.chars.map(&:to_i) }
    @max_x = @map.length
    @max_y = T.must(@map.first).length
    self
  end

  sig { returns(Integer) }
  def analyze
    find_low_points
    find_basins
    analyze_largest_basins
  end

  sig { returns(Integer) }
  def analyze_low_points
    find_low_points
    @low_points.map { |(x, y)| @map[x][y] }.sum + @low_points.length
  end

  sig { void }
  def find_low_points
    @low_points = []
    @map.each_with_index do |row, x|
      row.each_with_index do |cur, y|
        next if cur == 9

        adjacent = analyze_adjacent(x, y)
        next unless T.must(adjacent[:lower]).none? && T.must(adjacent[:higher]).any?

        @low_points << [x, y]
      end
    end
  end

  sig { void }
  def find_basins
    @basins = @low_points.map do |(x, y)|
      calc_basin(x, y).uniq
    end
    @basins = @basins.sort_by(&:length).reverse
  end

  sig { returns(Integer) }
  def analyze_largest_basins
    @basins[0..2].map(&:length).inject(1) { |acc, basin_size| acc * basin_size }
  end

  # rubocop:disable Naming/MethodParameterName
  sig { params(x: Integer, y: Integer).returns(T::Array[T::Array[Integer]]) }
  def calc_basin(x, y)
    adjacent = T.must(analyze_adjacent(x, y)[:higher])
    results = T.let([], T::Array[T::Array[Integer]])
    results << [x, y] unless @map[x][y] == 9

    adjacent.each do |(adj_x, adj_y)|
      adjacent_result = calc_basin(T.must(adj_x), T.must(adj_y))
      next if adjacent_result.none?

      results += adjacent_result
    end

    results
  end

  sig { params(x: Integer, y: Integer).returns(T::Hash[Symbol, T::Array[T::Array[Integer]]]) }
  def analyze_adjacent(x, y)
    val = @map[x][y]
    result = { lower: [], higher: [] }
    [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].each do |(new_x, new_y)|
      next unless valid_coord?(new_x, new_y)

      cur = @map.dig(new_x, new_y)
      next unless cur

      key = val < cur ? :higher : :lower
      result[key] << [new_x, new_y]
    end

    result
  end

  sig { params(x: Integer, y: Integer).returns(T::Boolean) }
  def valid_coord?(x, y)
    x <= @max_x && x >= 0 && y <= @max_y && y >= 0
  end
  # rubocop:enable Naming/MethodParameterName
end
