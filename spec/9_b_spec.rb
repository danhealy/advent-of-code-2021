# typed: ignore
# frozen_string_literal: true

Bundler.require
require_relative '../9_b'

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
    it 'returns the low points' do
      map.find_low_points
      expect(map.low_points).to eq([[0, 1], [0, 9], [2, 2], [4, 6]])
    end
  end

  describe '#analyze_low_points' do
    it 'finds the sum of all low points, plus one for each' do
      expect(map.analyze_low_points).to eq(15)
    end
  end

  describe '#analyze' do
    it 'finds the top three largest basins and multiplies their values' do
      expect(map.analyze).to eq(1134)
    end
  end

  describe '#analyze_largest_basins' do
    it 'returns the product of the top 3 basins based on point sizes' do
      map.basins = [[1], [1, 2], [1, 2, 3]]
      expect(map.analyze_largest_basins).to eq(1 * 2 * 3)
    end
  end

  # TODO: #calc_basin

  describe '#analyze_adjacent' do
    it 'returns higher and lower adjacent points' do
      expect(map.analyze_adjacent(1, 2)).to eq(
        {
          higher: [[0, 2], [1, 1]],
          lower: [[2, 2], [1, 3]]
        }
      )
    end
  end

  describe '#valid_coord?' do
    let(:valid_x) { map.max_x - 1 }
    let(:valid_y) { map.max_y - 1 }
    it 'returns true if coord is within bounds' do
      expect(map.valid_coord?(valid_x, valid_y)).to eq(true)
    end

    it 'returns false if x is below bounds' do
      expect(map.valid_coord?(-1, valid_y)).to eq(false)
    end

    it 'returns false if x is above bounds' do
      expect(map.valid_coord?(map.max_x + 1, valid_y)).to eq(false)
    end

    it 'returns false if y is below bounds' do
      expect(map.valid_coord?(valid_x, -1)).to eq(false)
    end

    it 'returns false if y is above bounds' do
      expect(map.valid_coord?(valid_x, map.max_y + 1)).to eq(false)
    end
  end
end
