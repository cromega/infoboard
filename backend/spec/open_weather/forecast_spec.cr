require "../spec_helper"

module OpenWeather
  describe Forecast do
    describe "time" do
      it "returns the reading timestamp" do
        forecast = Forecast.new(ForecastEntry.from_json(File.read("spec/fixtures/forecast_entry.json")))
        forecast.time.should eq "12:00"
      end
    end

    describe "#icon" do
      it "returns the weather icon" do
        forecast = Forecast.new(ForecastEntry.from_json(File.read("spec/fixtures/forecast_entry.json")))
        forecast.icon.should eq "01d"
      end
    end

    describe "#temp_min" do
      it "returns the min temperature deviation" do
        forecast = Forecast.new(ForecastEntry.from_json(File.read("spec/fixtures/forecast_entry.json")))
        forecast.temp_min.should eq 281.556
      end
    end

    describe "#temp_max" do
      it "returns the max temperature deviation" do
        forecast = Forecast.new(ForecastEntry.from_json(File.read("spec/fixtures/forecast_entry.json")))
        forecast.temp_max.should eq 286.67
      end
    end

    describe "#wind" do
      it "returns the wind speed" do
        forecast = Forecast.new(ForecastEntry.from_json(File.read("spec/fixtures/forecast_entry.json")))
        forecast.wind.should eq 1.81
      end
    end

    describe "#rain" do

    end

    describe "#to_json" do

    end
  end
end
