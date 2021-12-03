# typed: ignore
# frozen_string_literal: true

Bundler.require
require_relative '../2_b'

RSpec.describe Instruction do
  let(:directions) { %i[forward down forward up down forward] }
  let(:units) { [5, 5, 8, 3, 8, 2] }
  let(:test_data) do
    directions.zip(units).map { |instruction| instruction.join(' ') }.join("\n")
  end
  describe '.parse_raw' do
    subject(:result) { Instruction.parse_raw(test_data) }
    it 'maps directions' do
      expect(result.map(&:direction)).to eq(directions)
    end
    it 'maps units' do
      expect(result.map(&:units)).to eq(units)
    end
  end
end

RSpec.describe Submarine do
  describe '#follow_instructions' do
    let(:directions) { %i[forward down forward up down forward] }
    let(:units) { [5, 5, 8, 3, 8, 2] }
    let(:instructions) { directions.zip(units).map { |instruction| Instruction.new(*instruction) } }

    subject(:result) { Submarine.new.follow_instructions(instructions) }
    it 'follows all positions' do
      expect(result.position).to eq(5 + 8 + 2)
    end
    it 'follows all depths' do
      expect(result.depth).to eq(0 + (8 * 5) + (10 * 2))
    end
  end

  describe '#follow_instruction' do
    let(:magnitude) { rand(10) }
    let(:direction) { :forward }
    let(:aim) { rand(10) }
    let(:instruction) { Instruction.new(direction, magnitude) }
    subject(:result) { Submarine.new(aim: aim).follow_instruction(instruction) }

    context 'when aiming down' do
      let(:direction) { :down }
      it 'does not change position' do
        expect(result.position).to eq(0)
      end
      it 'does not change depth' do
        expect(result.depth).to eq(0)
      end
      it 'increases aim' do
        expect(result.aim).to eq(aim + magnitude)
      end
    end

    context 'when aiming up' do
      let(:direction) { :up }
      it 'does not change position' do
        expect(result.position).to eq(0)
      end
      it 'does not change depth' do
        expect(result.depth).to eq(0)
      end
      it 'decreases aim' do
        expect(result.aim).to eq(aim - magnitude)
      end
    end

    context 'when moving forward' do
      let(:direction) { :forward }
      it 'changes depth' do
        expect(result.depth).to eq(aim * magnitude)
      end
      it 'increases position' do
        expect(result.position).to eq(magnitude)
      end
    end
  end

  describe '#dead_reckoning' do
    let(:depth) { rand(-100..100) }
    let(:position) { rand(0..100) }
    let(:sub) { Submarine.new }
    before do
      sub.depth = depth
      sub.position = position
    end
    subject(:result) { sub.dead_reckoning }
    it 'returns the multplied depth and position' do
      expect(result).to eq(depth * position)
    end
  end
end
