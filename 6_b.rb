# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      ecosystem = Ecosystem.new
      ecosystem.seed_lanternfish(input.split(',').map(&:to_i))
      ecosystem.simulate(256)
      puts "Lanternfish: #{ecosystem.total_lanternfish}"
    end
  end
end

class Ecosystem
  extend T::Sig

  sig { returns(T::Array[Integer]) }
  attr_accessor :lanternfish

  sig { returns(T::Array[Integer]) }
  attr_accessor :ineligible_lanternfish

  sig { returns(Integer) }
  attr_accessor :current_day

  sig { void }
  def initialize
    @lanternfish = Array.new(7, 0)
    @ineligible_lanternfish = Array.new(7, 0)
    @current_day = 0
  end

  sig { params(new_fish: T::Array[Integer]).returns(T.self_type) }
  def seed_lanternfish(new_fish)
    new_fish.each do |fish|
      @lanternfish[fish] += 1
    end
    @ineligible_lanternfish = Array.new(7, 0)
    self
  end

  sig { params(days: Integer).void }
  def simulate(days)
    days.times { simulate_day }
  end

  sig { returns(Integer) }
  def total_lanternfish
    lanternfish.sum
  end

  private

  sig { void }
  def simulate_day
    new_fish = @lanternfish[@current_day] - @ineligible_lanternfish[@current_day]
    population_day = (@current_day + 2) % 7
    next_day = (@current_day + 1) % 7
    @lanternfish[population_day] += new_fish
    @ineligible_lanternfish[population_day] = new_fish
    @current_day = next_day
  end
end
