# typed: ignore
# frozen_string_literal: true

Bundler.require
require_relative '../5_a'

RSpec.describe Map do
  let(:test_data_string) do
    [
      '0,9 -> 5,9',
      '8,0 -> 0,8',
      '9,4 -> 3,4',
      '2,2 -> 2,1',
      '7,0 -> 7,4',
      '6,4 -> 2,0',
      '0,9 -> 2,9',
      '3,4 -> 1,4',
      '0,0 -> 8,8',
      '5,5 -> 8,2'
    ]
  end
  let(:vertical)   { [0, 1, 0, 5] }
  let(:horizontal) { [0, 1, 4, 1] }
  let(:diagonal)   { [0, 1, 4, 5] }
  let(:map)        { Map.new }

  describe '#draw_line!' do
    it 'does not draw if the line is not vertical or horizontal' do
      expect { map.draw_line!(*diagonal) }.not_to(change { map.grid })
    end

    it 'can draw a vertical line' do
      map.draw_line!(*vertical)
      expect(map.grid[0][1..5]).to eq([1] * 5)
    end

    it 'can draw a horizontal line' do
      map.draw_line!(*horizontal)
      expect(map.grid.transpose[1][0..4]).to eq([1] * 5)
    end

    it 'can overlap lines' do
      map.draw_line!(*horizontal)
      map.draw_line!(*vertical)
      expect(map.grid[0][1]).to eq(2)
    end
  end

  describe '#draw_lines_from_raw!' do
    before do
      map.draw_lines_from_raw!(test_data_string.join("\n"))
    end

    it 'sets overlapping lines' do
      expect(map.grid[0][9]).to eq(2)
    end
  end
end
