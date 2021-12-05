# typed: true
# frozen_string_literal: true

class Level
  class << self
    def run(input)
      bingo = Bingo.from_raw(input)
      winner = bingo.last_winner!
      puts "Score: #{T.must(winner).unmarked_sum * T.must(bingo.current_draw)}"
    end
  end
end

class BoardNumber
  extend T::Sig

  sig { returns(Integer) }
  attr_accessor :number

  sig { returns(T::Boolean) }
  attr_accessor :marked

  sig { params(number: Integer).void }
  def initialize(number)
    @number = number
    @marked = false
  end

  sig { params(draw: Integer).void }
  def mark!(draw)
    @marked = true if draw == @number
  end
end

class Board
  extend T::Sig

  sig { returns(T::Array[T::Array[BoardNumber]]) }
  attr_accessor :numbers

  class << self
    extend T::Sig

    sig { params(board_lines: T::Array[T::Array[String]]).returns(T::Array[Board]) }
    def from_lines(board_lines)
      board_lines.map do |lines|
        Board.new(
          lines.map do |line|
            line.split.map do |number|
              BoardNumber.new(number.to_i)
            end
          end
        )
      end
    end
  end

  sig { params(numbers: T::Array[T::Array[BoardNumber]]).void }
  def initialize(numbers = [])
    @numbers = T.must(numbers)
  end

  sig { params(draw: Integer).void }
  def mark!(draw)
    T.must(numbers).each do |row|
      T.must(row).each do |number|
        number.mark!(draw)
      end
    end
  end

  sig { returns(T::Boolean) }
  def winner?
    [numbers, T.must(numbers).transpose].each do |set|
      return true if T.let(set, T::Array[T::Array[BoardNumber]]).any? { |row| row.all?(&:marked) }
    end
    false
  end

  sig { returns(Integer) }
  def unmarked_sum
    numbers.flatten.reject(&:marked).map(&:number).sum
  end
end

class Bingo
  extend T::Sig

  sig { returns(Array) }
  attr_accessor :boards

  sig { returns(Array) }
  attr_accessor :draw

  sig { returns(Integer) }
  attr_accessor :draw_idx

  class << self
    extend T::Sig

    sig { params(data_string: String).returns(Bingo) }
    def from_raw(data_string)
      bingo = Bingo.new
      lines = data_string.split("\n")
      bingo.draw = T.must(lines.shift).split(',').map(&:to_i)
      board_lines = []
      while lines.any?
        lines.shift
        board_lines << lines.shift(5)
      end
      bingo.boards = Board.from_lines(board_lines)
      bingo
    end
  end

  sig { params(draw: Array, boards: Array).void }
  def initialize(draw: [], boards: [])
    @draw_idx = 0
    @draw = draw
    @boards = boards
  end

  sig { returns(T.nilable(Board)) }
  def draw_all!
    while draw[draw_idx]
      winner = draw!
      return winner if winner

      @draw_idx += 1
    end
  end

  sig { returns(T.nilable(Board)) }
  def last_winner!
    losers = @boards
    while draw[draw_idx]
      winners = losers.select do |board|
        board.mark!(draw[draw_idx])
        board.winner?
      end
      losers -= winners
      return winners.first if losers.empty?

      @draw_idx += 1
    end
  end

  sig { returns(T.nilable(Board)) }
  def draw!
    winners = @boards.select do |board|
      board.mark!(draw[draw_idx])
      board.winner?
    end
    winners.first
  end

  sig { returns(T.nilable(Integer)) }
  def current_draw
    draw[draw_idx]
  end
end
