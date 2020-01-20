require "./forecast"
require "./entities"
require "../fetcher"

module OpenWeather
  class Checker
    BASE_URL = "https://api.openweathermap.org/data/2.5/forecast"

    def initialize(@token : String); end

    def forecast : Array(Forecast)
      Fetcher(ForecastResponse).new.fetch(url).list
        .first(4)
        .map { |forecast| Forecast.new(forecast) }
    end

    private def url : String
      params = HTTP::Params.encode({
        mode: "json",
        q: "London,uk",
        units: "metric",
        cnt: "4",
        appid: token
      })

      "#{BASE_URL}?#{params}"
    end

    private def token : String
      ENV["OPENWEATHERMAP_API_TOKEN"]
    end
  end
end
