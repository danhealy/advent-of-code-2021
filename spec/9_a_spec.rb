# typed: ignore
# frozen_string_literal: true

Bundler.require
require_relative '../9_a'

RSpec.describe Map do
  let(:test_data_string) do
    %w[
      2199943210
      3987894921
      9856789892
      8767896789
      9899965678
    ].join("\n")
  end

  let(:map) { Map.new.seed(test_data_string) }

  describe '#find_low_points' do
    it 'finds the sum of all low points, plus one for each' do
      expect(map.find_low_points).to eq(15)
    end
  end
end
