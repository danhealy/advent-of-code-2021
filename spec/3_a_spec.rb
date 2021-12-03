# typed: ignore
# frozen_string_literal: true

Bundler.require
require_relative '../3_a'

RSpec.describe Status do
  let(:test_data) {
    %w[
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    ]
  }
  let(:test_data_chars) { test_data.map(&:chars) }
  let(:status) { Status.new(test_data_chars) }

  describe ".from_raw_diagnostics" do
    subject(:result) { Status.from_raw_diagnostics(test_data.join("\n")) }
    it "returns a Status with diagnostics set" do
      expect(result.diagnostics).to eq(test_data_chars)
    end
  end

  describe "#analyze!" do
    subject(:result) do
      status.analyze!
      status.most_common_bits
    end
    it "sets most_common_bits correctly" do
      expect(result).to eq(0b10110)
    end
  end

  describe "#power_consumption" do
    let(:status) do
      status = Status.new(test_data_chars)
      status.mask = 0b11111
      status.most_common_bits = 0b10110
      status
    end
    subject(:result) { status.power_consumption }

    it "multiplies gamma and epsilon rate correctly" do
      expect(result).to eq(198)
    end
  end
end
