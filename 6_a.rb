# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      ecosystem = Ecosystem.new
      ecosystem.lanternfish = input.split(',').map(&:to_i)
      ecosystem.simulate(80)
      puts "Lanternfish: #{ecosystem.lanternfish.length}"
    end
  end
end

class Ecosystem
  extend T::Sig

  sig { returns(T::Array[Integer]) }
  attr_accessor :lanternfish

  sig { void }
  def initialize
    @lanternfish = []
  end

  sig { params(new_fish: T::Array[Integer]).returns(T.self_type) }
  def seed_lanternfish(new_fish)
    @lanternfish = new_fish
    self
  end

  sig { params(days: Integer).void }
  def simulate(days)
    days.times { simulate_day }
  end

  sig { returns(Integer) }
  def total_lanternfish
    lanternfish.length
  end

  private

  sig { void }
  def simulate_day
    added = []
    lanternfish.map! do |fish|
      new_day = (fish - 1)
      if new_day == -1
        added << 8
        6
      else
        new_day
      end
    end
    @lanternfish += added
  end
end
