require "kemal"
require "./tfl/checker"
require "./open_weather/checker"

module InfoboardBackend
  VERSION = "0.1.0"

  get "/status" do
    "OK"
  end

  class TflController
    def initialize
      @checker = TFL::Checker.new
    end

    def load
      get "/tube" do
        @checker.problems.to_json
      end
    end
  end

  class WeatherController
    def initialize
      @checker = OpenWeather::Checker.new(token: ENV["OPENWEATHERMAP_API_TOKEN"])
    end

    def load
      get "/weather" do
        @checker.forecast.to_json
      end
    end
  end


  def self.initialize
    TflController.new.load
    WeatherController.new.load
  end
end


InfoboardBackend.initialize
Kemal.run
