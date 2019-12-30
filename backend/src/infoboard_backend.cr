require "kemal"
require "./tfl/checker"
require "./open_weather/checker"

module InfoboardBackend
  VERSION = "0.1.0"

  get "/status" do
    "OK"
  end

  get "/tube" do
    TFL::Checker.new.problems.to_json
  end

  get "/weather" do
    OpenWeather::Checker.new.forecast.to_json
  end
end

Kemal.run
