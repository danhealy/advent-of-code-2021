# typed: ignore
# frozen_string_literal: true

Bundler.require
require_relative '../1_b'

RSpec.describe MeasurementWindow do
  let(:depths) { [1, 2, 3] }
  let(:measurements) { depths.map { |depth| Measurement.new(depth) } }
  let(:window) { MeasurementWindow.new(measurements) }
  describe '#total_depth' do
    it 'returns the sum of depths' do
      expect(window.total_depth).to eq(depths.sum)
    end
  end
end

RSpec.describe Sonar do
  let(:test_data) { [199, 200, 208, 210, 200, 207, 240, 269, 260, 263] }
  let(:test_data_string) { test_data.join("\n") }
  let(:sonar) { Sonar.from_measurements(test_data) }

  describe '.parse_raw_measurements' do
    subject(:result) { Sonar.parse_raw_measurements(test_data_string) }
    context 'when given test data string' do
      let(:data) { test_data }
      it 'converts the string to integer array' do
        expect(result).to eq(test_data)
      end
    end
  end

  describe '.from_measurements' do
    subject(:result) { sonar }
    context 'when given test data' do
      let(:data) { test_data }
      it 'returns Sonar' do
        expect(result).to be_a(Sonar)
      end
      it 'creates Measurments' do
        expect(result.measurements.map(&:class).uniq).to match_array([Measurement])
      end
      it 'creates the correct depths' do
        expect(result.measurements.map(&:depth)).to eq(test_data)
      end
      it 'creates MeasurementWindows' do
        expect(result.measurement_windows.map(&:class).uniq).to match_array([MeasurementWindow])
      end
    end
  end

  describe '#generate_measurement_windows!' do
    let(:depths) { [1, 2, 3, 4] }
    let(:measurements) { depths.map { |depth| Measurement.new(depth) } }
    let(:sonar) do
      new_sonar = Sonar.new
      new_sonar.measurements = measurements
      new_sonar
    end
    subject(:result) do
      sonar.generate_measurement_windows!
      sonar.measurement_windows
    end
    it 'creates MeasurementWindows' do
      expect(result.map(&:class).uniq).to match_array([MeasurementWindow])
    end
    it 'creates a MeasurementWindow for depth tuples' do
      expect(result.first.measurements).to eq(measurements.take(3))
    end
  end

  describe '#count_depth_increases' do
    subject(:result) { sonar.count_depth_increases }
    it 'returns count of increasing depths' do
      expect(result).to eq(7)
    end
  end

  describe '#count_window_increases' do
    subject(:result) { sonar.count_window_increases }
    it 'returns count of increasing depths of measurement windows' do
      expect(result).to eq(5)
    end
  end
end
