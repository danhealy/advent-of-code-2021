# typed: ignore
# frozen_string_literal: true

Bundler.require
require_relative '../4_a'

RSpec.describe Board do
  let(:test_board) do
    [
      [
        '22 13 17 11  0',
        ' 8  2 23  4 24',
        '21  9 14 16  7',
        ' 6 10  3 18  5',
        ' 1 12 20 15 19'
      ]
    ]
  end
  let(:board) { Board.from_lines(test_board).first }

  describe '#winner?' do
    before do
      0.upto 12 do |i|
        board.mark!(i)
      end
    end
    it 'returns false when not won' do
      expect(board.winner?).to eq(false)
    end
    it 'returns true when won' do
      board.mark!(13)
      expect(board.winner?).to eq(true)
    end
  end
end

RSpec.describe Bingo do
  let(:test_draw) do
    [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1]
  end

  let(:test_boards) do
    [
      '22 13 17 11  0',
      ' 8  2 23  4 24',
      '21  9 14 16  7',
      ' 6 10  3 18  5',
      ' 1 12 20 15 19',
      '',
      ' 3 15  0  2 22',
      ' 9 18 13 17  5',
      '19  8  7 25 23',
      '20 11 10 24  4',
      '14 21 16 12  6',
      '',
      '14 21 17 24  4',
      '10 16 15  9 19',
      '18  8 23 26 20',
      '22 11 13  6  5',
      ' 2  0 12  3  7'
    ].join("\n")
  end
  let(:test_data_string) { "#{test_draw.join(',')}\n\n" + test_boards }

  describe '.from_raw' do
    subject(:result) { Bingo.from_raw(test_data_string) }
    it 'sets draw' do
      expect(result.draw).to eq(test_draw)
    end
    it 'sets boards' do
      expect(result.boards.first).to be_a(Board)
    end
    it 'sets board numbers' do
      expect(result.boards.first.numbers.first.first.number).to eq(22)
    end
  end

  describe '#draw_all!' do
    let(:bingo) { Bingo.from_raw(test_data_string) }
    subject(:result) { bingo.draw_all! }
    it 'returns the winning board' do
      expect(result.unmarked_sum).to eq(188)
    end
    it 'finishes the draw at the correct number' do
      result
      expect(bingo.current_draw).to eq(24)
    end
  end
end
