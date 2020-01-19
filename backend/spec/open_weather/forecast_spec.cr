require "../spec_helper"

module OpenWeather
  describe Forecast do
    describe "#icon" do
      it "returns the weather icon" do
        forecast = Forecast.new(ForecastEntry.from_json(File.read("spec/fixtures/forecast_entry.json")))
        forecast.icon.should eq "01d"
      end
    end

    describe "#temp" do

    end

    describe "#rain" do

    end

    describe "#wind" do

    end

    describe "#to_json" do

    end
  end
end
