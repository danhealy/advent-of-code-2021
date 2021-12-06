# typed: ignore
# frozen_string_literal: true

Bundler.require
require_relative '../6_a'

RSpec.describe Ecosystem do
  let(:test_data_string) { [3, 4, 3, 1, 2] }
  let(:day1) { [2, 3, 2, 0, 1] }
  let(:day2) { [1, 2, 1, 6, 0, 8] }
  let(:ecosystem) { Ecosystem.new.seed_lanternfish(test_data_string) }

  describe '#simulate' do
    it 'models lanternfish reproduction (2 days)' do
      ecosystem.simulate(2)
      expect(ecosystem.total_lanternfish).to eq(6)
    end

    it 'models lanternfish reproduction (18 days)' do
      ecosystem.simulate(18)
      expect(ecosystem.total_lanternfish).to eq(26)
    end

    it 'models lanternfish reproduction (80 days)' do
      ecosystem.simulate(80)
      expect(ecosystem.total_lanternfish).to eq(5934)
    end
  end
end
