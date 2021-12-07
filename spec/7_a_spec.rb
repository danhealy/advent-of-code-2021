# typed: ignore
# frozen_string_literal: true

Bundler.require
require_relative '../7_a'

RSpec.describe CrabAlignment do
  let(:test_data_string) { [16, 1, 2, 0, 4, 2, 7, 1, 2, 14] }
  let(:crabs) { CrabAlignment.new.seed(test_data_string) }

  describe '#analyze!' do
    before do
      crabs.analyze!
    end

    it 'sets the optimal alignment' do
      expect(crabs.alignment).to eq(37)
    end
  end
end
